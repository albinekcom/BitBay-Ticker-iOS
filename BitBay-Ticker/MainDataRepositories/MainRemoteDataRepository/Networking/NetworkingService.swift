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
            let result: Result<Data, NetworkingServiceError>
            
            if let error = error {
                result = .failure(.networkError(error))
            } else if let data = data {
                result = .success(data)
            } else {
                result = .failure(.lackOfData)
            }
            
            DispatchQueue.main.async {
                completion?(result)
                self?.completion = nil
            }
        }
        
        task?.resume()
    }
    
    func cancelRequest() {
        task?.cancel()
        
        completion?(.failure(.canceled)) // NOTE: Check canceling, completion with .failure could be invoked
        completion = nil
    }
    
}
