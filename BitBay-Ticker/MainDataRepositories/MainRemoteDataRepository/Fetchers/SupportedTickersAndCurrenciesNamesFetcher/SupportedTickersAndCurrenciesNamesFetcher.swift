import Foundation

enum SupportedTickersAndCurrenciesNamesFetcherError: Error {
    
    case parsingError
    case genericError
    case canceled
    
}

final class SupportedTickersAndCurrenciesNamesFetcher {
    
    private let networkingService: NetworkingService
    private let jsonDecoder: JSONDecoder
    
    init(networkingService: NetworkingService = NetworkingService(),
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.networkingService = networkingService
        self.jsonDecoder = jsonDecoder
    }
    
    func fetchSupportedTickersAndCurrenciesNames(completion: @escaping ((Result<SupportedTickersAndCurrenciesNamesFetcherModel, SupportedTickersAndCurrenciesNamesFetcherError>) -> Void)) {
        networkingService.request(.supportedTickersAndCurrenciesNames) { [weak self] result in
            switch result {
            case .success(let data):
                guard let supportedTickersAPIResponse = try? self?.jsonDecoder.decode(SupportedTickersAndCurrenciesNamesFetcherAPIResponse.self, from: data) else {
                    completion(.failure(.parsingError))

                    return
                }
                
                completion(.success(SupportedTickersAndCurrenciesNamesFetcherModel(supportedTickersAPIResponse: supportedTickersAPIResponse)))
                
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
    
    func cancelFetching() {
        networkingService.cancelRequest()
    }
    
}
