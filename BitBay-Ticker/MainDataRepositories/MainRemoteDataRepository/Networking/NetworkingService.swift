import Foundation

enum NetworkingServiceError: Error {
    
    case invalidURL
    case networkError(Error)
    case lackOfData
    case parsingError
    case timeout
    case canceled
    
}

protocol NetworkingServiceConfiguration {
    
    var timeoutInterval: TimeInterval { get }
}

struct DefaultNetworkingServiceConfiguration: NetworkingServiceConfiguration {
    
    let timeoutInterval: TimeInterval = 10
}

final class NetworkingService {
    
    private let urlSession: URLSession
    private let configuration: NetworkingServiceConfiguration
    
    private var task: URLSessionTask?
    private var completion: ((Result<Data, NetworkingServiceError>) -> Void)?
    
    init(urlSession: URLSession = URLSession.shared,
         configuration: NetworkingServiceConfiguration = DefaultNetworkingServiceConfiguration()) {
        self.urlSession = urlSession
        self.configuration = configuration
    }
    
    func request(_ endpoint: Endpoint, completion: ((Result<Data, NetworkingServiceError>) -> Void)?) {
        self.completion = completion
        
        guard let url = endpoint.url else {
            self.completion?(.failure(.invalidURL))
            self.completion = nil
            
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = configuration.timeoutInterval
        
        task = urlSession.dataTask(with: urlRequest) { [weak self] data, _, error in
            defer {
                self?.completion = nil
            }
            
            if let error = error {
                self?.completion?(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                self?.completion?(.failure(.lackOfData))
                return
            }
            
            self?.completion?(.success(data))
        }
        
        task?.resume()
    }
    
    func cancelRequest() {
        task?.cancel()
        
        completion?(.failure(.canceled)) // NOTE: Check canceling, completion with .failure could be invoked
        completion = nil
    }
    
}
