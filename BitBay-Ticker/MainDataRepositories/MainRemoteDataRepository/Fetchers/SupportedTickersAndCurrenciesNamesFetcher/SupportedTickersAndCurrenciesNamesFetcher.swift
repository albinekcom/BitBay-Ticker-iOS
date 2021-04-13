import Foundation

enum SupportedTickersAndCurrenciesNamesFetcherError: Error {
    
    case parsingError
    case genericError
    
}

final class SupportedTickersAndCurrenciesNamesFetcher {
    
    private let networkingService: NetworkingService
    private let jsonDecoder: JSONDecoder
    
    private var lastSuccesfullyTickersIdentifiersFetchedDate: Date? {
        didSet {
            userDefaults?.setValue(lastSuccesfullyTickersIdentifiersFetchedDate, forKey: ApplicationConfiguration.Storing.lastRefreshingSupportedTickersDateKey)
        }
    }
    
    private let userDefaults: UserDefaults?
    
    init(networkingService: NetworkingService = NetworkingService(),
         jsonDecoder: JSONDecoder = JSONDecoder(),
         userDefaults: UserDefaults? = UserDefaults.shared) {
        self.networkingService = networkingService
        self.jsonDecoder = jsonDecoder
        self.userDefaults = userDefaults
        
        lastSuccesfullyTickersIdentifiersFetchedDate = userDefaults?.object(forKey: ApplicationConfiguration.Storing.lastRefreshingSupportedTickersDateKey) as? Date
    }
    
    func fetchSupportedTickersAndCurrenciesNames(completion: @escaping ((Result<SupportedTickersAndCurrenciesNamesFetcherModel, TickerPropertiesFetcherError>) -> Void)) {
        guard shouldRefreshSupportedTickersAndCurrenciesNames() else { return }
        
        networkingService.request(.supportedTickersAndCurrenciesNames) { [weak self] result in
            switch result {
            case .success(let data):
                guard let supportedTickersAPIResponse = try? self?.jsonDecoder.decode(SupportedTickersAndCurrenciesNamesFetcherAPIResponse.self, from: data) else {
                    completion(.failure(.parsingError))

                    return
                }
                
                self?.lastSuccesfullyTickersIdentifiersFetchedDate = Date()
                
                completion(.success(SupportedTickersAndCurrenciesNamesFetcherModel(supportedTickersAPIResponse: supportedTickersAPIResponse)))
                
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
    
    func cancelFetching() {
        networkingService.cancelRequest()
    }
    
    private func shouldRefreshSupportedTickersAndCurrenciesNames() -> Bool {
        guard let lastSuccesfullyTickersIdentifiersFetchedDate = lastSuccesfullyTickersIdentifiersFetchedDate else { return true }
        
        return Date().timeIntervalSince(lastSuccesfullyTickersIdentifiersFetchedDate) > ApplicationConfiguration.UserData.minimumTimeSpanBetweenTickerIndentifiersRefreshes
    }
    
}
