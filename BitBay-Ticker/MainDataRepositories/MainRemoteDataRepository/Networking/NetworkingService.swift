import Foundation

enum NetworkingServiceError: Error {
    
    case invalidURL
    case networkError(Error)
    case lackOfData
    case parsingError
    
}

final class NetworkingService {
    
    private struct Configuration {
        
        static let timeoutInterval: TimeInterval = 10
    }
    
    private let urlSession: URLSession
    
    private var task: URLSessionTask?
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request(_ endpoint: Endpoint, completion: @escaping ((Result<Data, NetworkingServiceError>) -> Void)) {
        guard let url = endpoint.url else { return completion(.failure(.invalidURL)) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = Configuration.timeoutInterval
        
        task = urlSession.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                return completion(.failure(.networkError(error)))
            }
            
            guard let data = data else {
                return completion(.failure(.lackOfData))
            }
            
            completion(.success(data))
        }
        
        task?.resume()
    }
    
    func cancelRequest() {
        task?.cancel()
    }
    
}
