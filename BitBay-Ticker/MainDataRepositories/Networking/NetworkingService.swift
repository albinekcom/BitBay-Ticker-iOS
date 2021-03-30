import Foundation

enum NetworkingServiceError: Error {
    
    case invalidURL
    case networkError(Error)
    case lackOfData
    case parsingError
    
}

final class NetworkingService {
    
    private let urlSession: URLSession
    
    private var task: URLSessionTask?
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request(_ endpoint: Endpoint, completion: @escaping ((Result<Data, NetworkingServiceError>) -> Void)) {
        guard let url = endpoint.url else { return completion(.failure(.invalidURL)) }
        
        task = urlSession.dataTask(with: url) { data, _, error in
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
