import Foundation

enum SupportedTickersAndCurrenciesNamesFetcherError: Error {
    
    case parsingError
    case genericError
    
}

final class SupportedTickersAndCurrenciesNamesFetcher {
    
    private let networkingService: NetworkingService
    private let jsonDecoder: JSONDecoder
    
    init(networkingService: NetworkingService = NetworkingService(),
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.networkingService = networkingService
        self.jsonDecoder = jsonDecoder
    }
    
    func fetchSupportedTickersAndCurrenciesNames(completion: @escaping ((Result<SupportedTickersAndCurrenciesNamesFetcherModel, TickerPropertiesFetcherError>) -> Void)) {
        networkingService.request(.supportedTickersAndCurrenciesNames) { [weak self] result in
            switch result {
            case .success(let data):
                guard let supportedTickersAPIResponse = try? self?.jsonDecoder.decode(SupportedTickersAndCurrenciesNamesFetcherAPIResponse.self, from: data) else {
                    completion(.failure(.parsingError))

                    return
                }
                
                let supportedTickersRemoteDataRepositoryModel = SupportedTickersAndCurrenciesNamesFetcherModel(supportedTickersAPIResponse: supportedTickersAPIResponse)
                completion(.success(supportedTickersRemoteDataRepositoryModel))
                
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
    
    func cancelFetching() {
        networkingService.cancelRequest()
    }
    
}
