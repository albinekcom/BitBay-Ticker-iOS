import Foundation

enum FetchingError: Error {
    
    case someError
    
}

final class MainDataRepository: TickersDataRepositoryProtocol,
                                CurrenciesDataRepositoryProtocol,
                                SupportedTickersDataRepositoryProtocol,
                                TickersAppendableDataRepositoryProtocol,
                                AutomaticTickersRefreshingProtocol {
    
    var isResumeAutomaticRefreshingTickersPossible: Bool = false
    
    private(set) var currencies: Set<Currency> = [] {
        didSet {
            currenciesDataDelegate?.didUpdateCurrencies()
        }
    }
    
    private(set) var supportedTickers: [SupportedTicker] = [] {
        didSet {
            supportedTickersDataDelegate?.didUpdateSupportedTickers()
        }
    }
    
    var tickers: [Ticker] = [] {
        didSet {
            tickersDataDelegate?.didUpdateTickers(error: nil)
        }
    }
    
    var analyticsService: AnalyticsService?
    
    private let mainLocalDataRepository: MainLocalDataRepository
    private let supportedTickersAndCurrenciesNamesFetcher: SupportedTickersAndCurrenciesNamesFetcher
    
    private var automaticRefreshingTickersTimer: Timer?
    
    weak var tickersDataDelegate: TickersDataRepositoryDelegate?
    weak var currenciesDataDelegate: CurrenciesDataRepositoryDelegate?
    weak var supportedTickersDataDelegate: SupportedTickersDataRepositoryDelegate?
    
    private(set) var dispatchGroup = DispatchGroup()
    private(set) var tickerFetchers: [TickerFetcher] = []
    private(set) var singleTickerFetcher: TickerFetcher = TickerFetcher(tickerIdentifier: "")
    
    var isSucessfulyRefreshedTickers = false
    
    init(mainLocalDataRepository: MainLocalDataRepository = MainLocalDataRepository(),
         supportedTickersAndCurrenciesNamesFetcher: SupportedTickersAndCurrenciesNamesFetcher = SupportedTickersAndCurrenciesNamesFetcher()) {
        self.mainLocalDataRepository = mainLocalDataRepository
        self.supportedTickersAndCurrenciesNamesFetcher = supportedTickersAndCurrenciesNamesFetcher
        
        mainLocalDataRepository.load() { [weak self] loadedData in
            self?.currencies = loadedData.currencies
            self?.supportedTickers = loadedData.supportedTickers
            self?.tickers = loadedData.tickers
            
            self?.isResumeAutomaticRefreshingTickersPossible = true
            self?.refreshSupportedTickersAndCurrenciesNames()
            self?.resumeAutomaticRefreshingTickers()
        }
    }
    
    @objc private func refreshTickers() {
        tickerFetchers.forEach { $0.cancelFetchingTicker() }
        
        let tickersIdentifiers = tickers.map { $0.identifier }
        
        tickerFetchers = tickersIdentifiers.map { TickerFetcher(tickerIdentifier: $0) }
        
        dispatchGroup = DispatchGroup()
        
        isSucessfulyRefreshedTickers = false
        
        tickerFetchers.forEach { [weak self] in
            dispatchGroup.enter()
            self?.refreshTicker(tickerFetcher: $0, source: .automatic)
        }
        
        dispatchGroup.notify(queue: .main) {
            let error: FetchingError?
            
            if self.isSucessfulyRefreshedTickers {
                self.analyticsService?.trackRefreshedTickers(tickerIdentifiers: tickersIdentifiers, source: .automatic)
                error = nil
            } else {
                self.analyticsService?.trackRefreshingTickersFailed(source: .automatic)
                error = .someError
            }
            
            self.currenciesDataDelegate?.didUpdateCurrencies()
            self.tickersDataDelegate?.didUpdateTickers(error: error)
        }
    }
    
    private func refreshTicker(tickerFetcher: TickerFetcher, source: AnalyticsFetchingSource) {
        tickerFetcher.fetchTicker() { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let (refreshedTicker, externalCurrenciesProperties)):
                    guard let tickerIndex = self.tickers.firstIndex(where: { $0.identifier == refreshedTicker.identifier }) else { return }
                        
                    self.tickers[tickerIndex] = refreshedTicker
                    
                    // NOTE: Simplfy overriding currencies
                    
                    if let firstExternalCurrenciesProperties = externalCurrenciesProperties.firstExternalCurrencyProperties {
                        for currency in self.currencies {
                            if currency.code == firstExternalCurrenciesProperties.currencyCode {
                                let newCurrency = Currency(code: currency.code,
                                                           name: currency.name,
                                                           minimumOffer: currency.minimumOffer,
                                                           scale: firstExternalCurrenciesProperties.scale)
                                
                                self.currencies.insert(newCurrency)
                            }
                        }
                    }
                    
                    if let secondExternalCurrenciesProperties = externalCurrenciesProperties.secondExternalCurrencyProperties {
                        for currency in self.currencies {
                            if currency.code == secondExternalCurrenciesProperties.currencyCode {
                                let newCurrency = Currency(code: currency.code,
                                                           name: currency.name,
                                                           minimumOffer: currency.minimumOffer,
                                                           scale: secondExternalCurrenciesProperties.scale)
                                
                                self.currencies.insert(newCurrency)
                            }
                        }
                    }
                    
                    self.isSucessfulyRefreshedTickers = true
                    
                    if source == .automaticAfterAddingTicker {
                        self.analyticsService?.trackRefreshedTickers(tickerIdentifiers: [refreshedTicker.identifier], source: .automaticAfterAddingTicker)
                    }
                    
                case .failure:
                    self.isSucessfulyRefreshedTickers = false
                }
                
                if source == .automatic {
                    self.dispatchGroup.leave()
                }
            }
        }
    }
    
    private func refreshSupportedTickersAndCurrenciesNames() {
        supportedTickersAndCurrenciesNamesFetcher.fetchSupportedTickersAndCurrenciesNames() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.supportedTickers = data.supportedTickers
                    self?.currencies = data.currencies // NOTE: Add updating currencies istead of overwritting them here
                    
                    self?.removeNotSupportedTickers()
                    
                case .failure:
                    return
                }
            }
        }
    }
    
    private func removeNotSupportedTickers() {
        let tickersIdentifiers = Set(tickers.map { $0.identifier })
        let supportedTickersIdentifiers = Set(supportedTickers.map { $0.identifier })
        
        let tickersToRemoveIdentifiers = tickersIdentifiers.subtracting(supportedTickersIdentifiers)
        
        tickers.removeAll { tickersToRemoveIdentifiers.contains($0.identifier) }
        
        tickersDataDelegate?.didUpdateTickers(error: nil)
    }
    
    func saveDataLocally() {
        mainLocalDataRepository.save(supportedTickers: supportedTickers, currencies: currencies, tickers: tickers)
    }
    
    //
    
    func ticker(for identifier: String) -> Ticker? { // NOTE: Use it instead "tickers" in a places which needs just one paricular ticker
        tickers.filter({ $0.identifier == identifier }).first
    }
    
    func appendNewTicker(with identifier: String) {
        if tickers.contains(where: { $0.identifier == identifier}) {
            return
        }
        
        let ticker = Ticker(identifier: identifier, highestBid: nil, lowestAsk: nil, rate: nil, previousRate: nil, highestRate: nil, lowestRate: nil, volume: nil, average: nil)
        
        tickers.append(ticker)
        
        let singleTickerFetcher = TickerFetcher(tickerIdentifier: identifier)
        
        refreshTicker(tickerFetcher: singleTickerFetcher, source: .automaticAfterAddingTicker)
        
        tickersDataDelegate?.didUpdateTickers(error: nil)
    }
    
    func currency(for identifier: String) -> Currency? { // NOTE: Use it instead "tickers" in a places which needs just one paricular ticker
        Array(currencies).filter { $0.code == identifier }.first
    }
    
    func resumeAutomaticRefreshingTickers() {
        guard isResumeAutomaticRefreshingTickersPossible else { return }
        
        automaticRefreshingTickersTimer?.invalidate()
        automaticRefreshingTickersTimer = Timer.scheduledTimer(timeInterval: ApplicationConfiguration.UserData.timeSpanBetweenAutomaticRefreshingTicker,
                                                               target: self,
                                                               selector: #selector(fireTimer),
                                                               userInfo: nil,
                                                               repeats: true) // NOTE: Invoke "refreshTickers" before release
        automaticRefreshingTickersTimer?.fire()
    }
    
    func pauseAutomaticRefreshingTickers() {
        automaticRefreshingTickersTimer?.invalidate()
    }
    
    @objc private func fireTimer() { // NOTE: Remove this method before shipping
//        print("🔥 Timer fired!")
    }
    
}
