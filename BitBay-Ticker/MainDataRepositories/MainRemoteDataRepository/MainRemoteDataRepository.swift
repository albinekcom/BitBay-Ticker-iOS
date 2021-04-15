import Foundation

struct MainRemoteDataModel {
    
    let supportedTickers: [SupportedTicker]?
    let currencies: [String: Currency]
    let tickers: [String: Ticker]
    
}

enum MainRemoteDataRepositoryError: Error {
    
    case generic
    case canceled
}

final class MainRemoteDataRepository {
    
    var isSucessfulyRefreshedTickers: Bool { isSucessfulyRefreshedMultipleTickerFetchers.contains(false) == false }
    private(set) var isSucessfulyRefreshedSupportedTickers = false
    
    private let supportedTickersAndCurrenciesNamesFetcher: SupportedTickersAndCurrenciesNamesFetcher
    
    private var multipleTickerFetchers: [TickerAndExternalCurrenciesPropertiesFetcher] = []
    private var isSucessfulyRefreshedMultipleTickerFetchers: [Bool] = []
    
    private var fetchedTickersResults: [String: Result<Ticker, MainRemoteDataRepositoryError>] = [:]
    private var fetchedExternalCurrenciesPropertiesResults: [String: Result<String, MainRemoteDataRepositoryError>] = [:]
    
    private var dispatchGroup: DispatchGroup = DispatchGroup()
    private var shouldFetchSupportedTickers: Bool { true } // NOTE: Compare date
    private var completion: ((Result<MainRemoteDataModel, MainRemoteDataRepositoryError>) -> Void)?
    private let userDefaults: UserDefaults?
    
    init(supportedTickersAndCurrenciesNamesFetcher: SupportedTickersAndCurrenciesNamesFetcher = SupportedTickersAndCurrenciesNamesFetcher(),
         userDefaults: UserDefaults? = UserDefaults.shared) {
        self.supportedTickersAndCurrenciesNamesFetcher = supportedTickersAndCurrenciesNamesFetcher
        self.userDefaults = userDefaults
        
        lastSuccesfullyTickersIdentifiersFetchedDate = userDefaults?.object(forKey: ApplicationConfiguration.Storing.lastRefreshingSupportedTickersDateKey) as? Date
    }
    
    private var lastSuccesfullyTickersIdentifiersFetchedDate: Date? {
        didSet {
            userDefaults?.setValue(lastSuccesfullyTickersIdentifiersFetchedDate, forKey: ApplicationConfiguration.Storing.lastRefreshingSupportedTickersDateKey)
        }
    }
    
    private func shouldRefreshSupportedTickersAndCurrenciesNames() -> Bool {
        guard let lastSuccesfullyTickersIdentifiersFetchedDate = lastSuccesfullyTickersIdentifiersFetchedDate else { return true }
        
        return Date().timeIntervalSince(lastSuccesfullyTickersIdentifiersFetchedDate) > ApplicationConfiguration.UserData.minimumTimeSpanBetweenTickerIndentifiersRefreshes
    }
    
    func fetchRemoteData(tickersIdentifiers: [String], completion: ((Result<MainRemoteDataModel, MainRemoteDataRepositoryError>) -> Void)?) {
        self.completion = completion
        
        var supportedTickers: [SupportedTicker]?
        var currenciesNames: [String: String] = [:]
        var externalCurrenciesProperties: [String: ExternalCurrencyProperties] = [:]
        var tickers: [String: Ticker] = [:]
        
        dispatchGroup = DispatchGroup()
        
        isSucessfulyRefreshedSupportedTickers = false
        
        if shouldFetchSupportedTickers {
            dispatchGroup.enter()
            
            supportedTickersAndCurrenciesNamesFetcher.fetchSupportedTickersAndCurrenciesNames() { [weak self] result in
                switch result {
                case .success(let values):
                    supportedTickers = values.supportedTickers
                    currenciesNames = values.currenciesNames
                    
                    self?.isSucessfulyRefreshedSupportedTickers = true
                    self?.lastSuccesfullyTickersIdentifiersFetchedDate = Date()
                    
                case .failure(let error):
                    switch error {
                    case .parsingError, .genericError:
                        self?.isSucessfulyRefreshedSupportedTickers = false
                        
                    case .canceled:
                        break
                    }
                    
                }
                
                self?.dispatchGroup.leave()
            }
        }
        
        multipleTickerFetchers = tickersIdentifiers.map { TickerAndExternalCurrenciesPropertiesFetcher(tickerIdentifier: $0) }
        isSucessfulyRefreshedMultipleTickerFetchers = []
        
        multipleTickerFetchers.forEach {
            dispatchGroup.enter()
            
            $0.fetchTickersAndExternalCurrenciesProperties { [weak self] result in
                switch result {
                case .success(let values):
                    tickers[values.ticker.identifier] = values.ticker
                    
                    values.externalCurrenciesProperties.forEach {
                       externalCurrenciesProperties[$0.key] = $0.value
                    }
                    
                    self?.isSucessfulyRefreshedMultipleTickerFetchers.append(true)
                    
                case .failure(let error):
                    switch error {
                    case .genericError, .parsingError:
                        self?.isSucessfulyRefreshedMultipleTickerFetchers.append(false)
                    
                    case .canceled:
                        break
                    }
                    
                }
                
                self?.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            let currenciesNamesKeys = Set(currenciesNames.map { $0.key })
            let externalCurrenciesPropertiesKeys = Set(externalCurrenciesProperties.map { $0.key })
            
            let currenciesKeys = Set(currenciesNamesKeys.union(externalCurrenciesPropertiesKeys))
            
            var currencies: [String: Currency] = [:]
            
            for currencyKey in currenciesKeys {
                currencies[currencyKey] = Currency(code: currencyKey,
                                                   name: currenciesNames[currencyKey],
                                                   scale: externalCurrenciesProperties[currencyKey]?.scale)
            }
            
            let mainRemoteDataModel = MainRemoteDataModel(supportedTickers: supportedTickers,
                                                          currencies: currencies,
                                                          tickers: tickers)
            
            self?.completion?(.success(mainRemoteDataModel))
            self?.completion = nil
        }
    }
    
    func cancelFetching() {
        dispatchGroup = DispatchGroup()
        
        supportedTickersAndCurrenciesNamesFetcher.cancelFetching()
        
        multipleTickerFetchers.forEach { $0.cancelFetching() }
        multipleTickerFetchers = []
        
        DispatchQueue.main.async { [weak self] in
            self?.completion?(.failure(.canceled))
            self?.completion = nil
        }
    }
    
}
