import Foundation

final class MainDataRepository: TickersDataRepositoryProtocol,
                                CurrenciesDataRepositoryProtocol,
                                SupportedTickersDataRepositoryProtocol,
                                TickersAppendableDataRepositoryProtocol,
                                AutomaticTickersRefreshingProtocol,
                                MainDataRepositoryProtocol {
    
    var isResumeAutomaticRefreshingTickersPossible: Bool = false
    
    private(set) var currencies: [String: Currency] = [:] {
        didSet {
            currenciesDataDelegate?.didUpdateCurrencies()
        }
    }
    
    private(set) var supportedTickers: [SupportedTicker] = [] {
        didSet {
            supportedTickersDataDelegate?.didUpdateSupportedTickers()
        }
    }
    
    var userTickers: [Ticker] = [] {
        didSet {
            tickersDataDelegate?.didUpdateTickers(error: nil)
        }
    }
    
    var analyticsService: AnalyticsService?
    
    private let mainLocalDataRepository: MainLocalDataRepository
    private let mainRemoteDataRepository: MainRemoteDataRepository
    
    private var refreshingTickersTimer: ResumableTimer?
    
    weak var tickersDataDelegate: TickersDataRepositoryDelegate?
    weak var currenciesDataDelegate: CurrenciesDataRepositoryDelegate?
    weak var supportedTickersDataDelegate: SupportedTickersDataRepositoryDelegate?
    weak var mainDataRepositoryDelegate: MainDataRepositoryDelegate?
    
    init(mainLocalDataRepository: MainLocalDataRepository = MainLocalDataRepository(),
         mainRemoteDataRepository: MainRemoteDataRepository = MainRemoteDataRepository()) {
        self.mainLocalDataRepository = mainLocalDataRepository
        self.mainRemoteDataRepository = mainRemoteDataRepository
        
        mainLocalDataRepository.load() { [weak self] loadedData in
            self?.currencies = loadedData.currencies
            self?.supportedTickers = loadedData.supportedTickers
            self?.userTickers = loadedData.userTickers
            
            self?.isResumeAutomaticRefreshingTickersPossible = true
            self?.refreshRemoteData()
            self?.mainDataRepositoryDelegate?.didLoadLocalData()
        }
    }
    
    func saveDataLocally() {
        mainLocalDataRepository.save(supportedTickers: supportedTickers, currencies: currencies, userTickers: userTickers)
    }
    
    func ticker(for identifier: String) -> Ticker? { // NOTE: Use it instead "tickers" in a places which needs just one paricular ticker
        userTickers.filter { $0.identifier == identifier }.first
    }
    
    func appendNewTicker(with identifier: String) {
        if userTickers.contains(where: { $0.identifier == identifier}) {
            return
        }
        
        let ticker = Ticker(identifier: identifier)
        
        userTickers.append(ticker)
        tickersDataDelegate?.didUpdateTickers(error: nil)
        
        mainRemoteDataRepository.fetchRemoteData(tickerIdentifier: identifier) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let remoteModel):
                self.updateValues(remoteModel: remoteModel)
                
            case .failure:
                break
            }
        }
    }
    
    func currency(for identifier: String) -> Currency? {
        currencies[identifier]
    }
    
    func resumeAutomaticRefreshingTickers() {
        guard isResumeAutomaticRefreshingTickersPossible else { return }
        
        mainRemoteDataRepository.cancelFetching()
        
        refreshingTickersTimer?.resume()
    }
    
    func pauseAutomaticRefreshingTickers() {
        mainRemoteDataRepository.cancelFetching()
        
        refreshingTickersTimer?.pause()
    }
    
    private func refreshRemoteData() {
        mainRemoteDataRepository.fetchRemoteData(tickersIdentifiers: userTickers.map { $0.identifier }) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let remoteModel):
                self.updateValues(remoteModel: remoteModel)
                
            case .failure(let error):
                print("Error: \(error)")
            }
            
            self.setUpTimer()
        }
    }
    
    private func setUpTimer() {
        let fireDate = Date(timeIntervalSinceNow: ApplicationConfiguration.UserData.timeSpanBetweenAutomaticRefreshingTicker)
        
        self.refreshingTickersTimer = ResumableTimer(fireDate: fireDate) { [weak self] in
            self?.refreshRemoteData()
        }
    }
    
    private func updateValues(remoteModel: MainRemoteDataModel) {
        // Supported tickers
        
        if let remoteModelSupportedTickers = remoteModel.supportedTickers {
            self.supportedTickers = remoteModelSupportedTickers
        }
        
        // Currencies
        
        for remoteModelCurrencyKey in remoteModel.currencies {
            let remoteCurrency = remoteModelCurrencyKey.value
            
            if let localCurrency = self.currencies[remoteCurrency.code] {
                let newName: String?
                
                if let remoteCurrencyName = remoteCurrency.name {
                    newName = remoteCurrencyName
                } else {
                    newName = localCurrency.name
                }
                
                let newScale: Int?
                
                if let remoteCurrencyScale = remoteCurrency.scale {
                    newScale = remoteCurrencyScale
                } else {
                    newScale = localCurrency.scale
                }
                
                self.currencies[remoteCurrency.code] = Currency(code: remoteCurrency.code, name: newName, scale: newScale)
            } else {
                self.currencies[remoteCurrency.code] = remoteCurrency
            }
        }
        
        // Tickers
        
        let supportedTickersIdentifiers = self.supportedTickers.map { $0.identifier }
        let filteredUserTickersBasedOnSupportedTickers = self.userTickers.filter { supportedTickersIdentifiers.contains($0.identifier) }
        let tickerIdentifiers = filteredUserTickersBasedOnSupportedTickers.map { $0.identifier }
        
        var newUserTickers: [Ticker] = []
        
        for tickerIdentifier in tickerIdentifiers {
            if let tickerFromRemoteModel = remoteModel.tickers[tickerIdentifier] {
                newUserTickers.append(tickerFromRemoteModel)
            } else if let old = filteredUserTickersBasedOnSupportedTickers.first(where: { $0.identifier == tickerIdentifier} ) {
                newUserTickers.append(old)
            }
        }
        
        self.userTickers = newUserTickers
    }
    
}
