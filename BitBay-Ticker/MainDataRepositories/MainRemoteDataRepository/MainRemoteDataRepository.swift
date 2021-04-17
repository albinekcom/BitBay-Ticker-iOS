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
    private var completion: ((Result<MainRemoteDataModel, MainRemoteDataRepositoryError>) -> Void)?
    private let userDefaults: UserDefaults?
    
    private var singleTicker: TickerAndExternalCurrenciesPropertiesFetcher!
    
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
    
    private var shouldRefreshSupportedTickersAndCurrenciesNames: Bool {
        guard let lastSuccesfullyTickersIdentifiersFetchedDate = lastSuccesfullyTickersIdentifiersFetchedDate else { return true }
        
        return Date().timeIntervalSince(lastSuccesfullyTickersIdentifiersFetchedDate) > ApplicationConfiguration.UserData.minimumTimeSpanBetweenTickerIndentifiersRefreshes
    }
    
    func fetchRemoteData(tickerIdentifier: String, completion: ((Result<MainRemoteDataModel, MainRemoteDataRepositoryError>) -> Void)?) {
        singleTicker = TickerAndExternalCurrenciesPropertiesFetcher(tickerIdentifier: tickerIdentifier)
        
        singleTicker.fetchTickersAndExternalCurrenciesProperties { result in
            switch result {
            case .success(let values):
                var externalCurrenciesProperties: [String: ExternalCurrencyProperties] = [:]
                var tickers: [String: Ticker] = [:]
                
                tickers[values.ticker.identifier] = values.ticker
                
                values.externalCurrenciesProperties.forEach {
                   externalCurrenciesProperties[$0.key] = $0.value
                }
                
                let externalCurrenciesPropertiesKeys = Set(externalCurrenciesProperties.map { $0.key })
                var currencies: [String: Currency] = [:]
                
                for currencyKey in externalCurrenciesPropertiesKeys {
                    currencies[currencyKey] = Currency(code: currencyKey,
                                                       name: nil,
                                                       scale: externalCurrenciesProperties[currencyKey]?.scale)
                }
                
                DispatchQueue.main.async {
                    completion?(.success(MainRemoteDataModel(supportedTickers: nil,
                                                             currencies: currencies,
                                                             tickers: tickers)))
                }
                
            case .failure:
                break
            }
        }
    }
    
    func fetchRemoteData(tickersIdentifiers: [String], completion: ((Result<MainRemoteDataModel, MainRemoteDataRepositoryError>) -> Void)?) {
        self.completion = completion // NOTE: This is problematic if it used by single fetch also
        
        var supportedTickers: [SupportedTicker]?
        var currenciesNames: [String: String] = [:]
        var externalCurrenciesProperties: [String: ExternalCurrencyProperties] = [:]
        var tickers: [String: Ticker] = [:]
        
        dispatchGroup = DispatchGroup() // NOTE: This is problematic (should be everything cancelled before it)
        
        isSucessfulyRefreshedSupportedTickers = false
        
        if shouldRefreshSupportedTickersAndCurrenciesNames {
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
                    tickers[values.ticker.identifier] = values.ticker // NOTE: Application sometimes crashes here (after working long)
                    
                    values.externalCurrenciesProperties.forEach {
                       externalCurrenciesProperties[$0.key] = $0.value // NOTE: Application sometimes crashes here (after working long)
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
        supportedTickersAndCurrenciesNamesFetcher.cancelFetching()
        
        multipleTickerFetchers.forEach { $0.cancelFetching() }
        multipleTickerFetchers = []
        dispatchGroup = DispatchGroup()
        
        DispatchQueue.main.async { [weak self] in
            self?.completion?(.failure(.canceled))
            self?.completion = nil
        }
    }
    
}
