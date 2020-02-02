import Foundation

final class UserData: ObservableObject {
    
    @Published var tickers: [Ticker] = []
    @Published var areTickersLoaded: Bool = false
    
    @Published private(set) var tickersIdentifiersAvailableToAdd: [TickerIdentifier] = []
    
    @Published private(set) var fetchingTickerPropertiesError: Error?
    @Published private(set) var fetchingTickerIdentifiersError: Error?
    
    var isEditing: Bool = false { // HACK
        didSet {
            if isEditing {
                invalidRefreshingTimer()
            } else if isAdding == false {
                setupRefreshingTimer()
            }
        }
    }
    
    var isAdding: Bool = false {
        didSet {
            if isAdding {
                invalidRefreshingTimer()
            } else {
                setupRefreshingTimer()
            }
        }
    }
    
    private var refreshingTimer: Timer?
    private var lastSuccesfullyTickersIdentifiersFetchedDate: Date?
    
    private let tickerIdentifiersFetcher: TickerIdentifiersFetcher = TickerIdentifiersFetcher()
    private let tickerRefreshersStore: TickerRefreshersStore = TickerRefreshersStore()
    
    func setupRefreshingTimer() {
        guard isEditing == false else { return }
        guard refreshingTimer == nil else { return }
        
        refreshingTimer = Timer.scheduledTimer(timeInterval: AppConfiguration.UserData.timeSpanBetweenTickerRefreshes, target: self, selector: #selector(refreshAllTickers), userInfo: nil, repeats: true)
    }
    
    func invalidRefreshingTimer() {
        refreshingTimer?.invalidate()
        refreshingTimer = nil
    }
    
    // MARK: - Managing
    
    func removeAvailableToAddTickerIdentifier(tickerIdentifier: TickerIdentifier) {
        tickersIdentifiersAvailableToAdd.removeAll { $0 == tickerIdentifier }
    }
    
    func appendAndRefreshTicker(from tickerIdentifier: TickerIdentifier) {
        let ticker = Ticker(id: tickerIdentifier.id)
        
        tickers.append(ticker)
        
        refresh(ticker: ticker)
    }
    
    func removeTicker(at index: Int) {
        let tickerToDelete = tickers.remove(at: index)
        
        let tickerIdentifiersOfUserTickers = tickers.map { TickerIdentifier(id: $0.id) }
        tickersIdentifiersAvailableToAdd = TickerIdentifiersStore.shared.tickerIdentifiers.filter { tickerIdentifiersOfUserTickers.contains($0) == false }
        
        let analyticsParamaters = AnalyticsParametersFactory.makeParameters(from: tickerToDelete)
        AnalyticsService.shared.trackRemovedTicker(parameters: analyticsParamaters)
    }
    
    // MARK: - Refreshing
    
    @objc func refreshAllTickers() {
        tickers.forEach { refresh(ticker: $0) }
    }
    
    func refresh(ticker: Ticker) {
        tickerRefreshersStore.tickersRefresher(for: ticker).refresh() { [weak self] result in
            switch result {
                case .success(let refreshedTicker):
                    if let tickerIndex = self?.tickers.firstIndex(where: { $0.id == ticker.id }) {
                        self?.tickers[tickerIndex] = refreshedTicker
                    }
                    
                    let analyticsParameters = AnalyticsParametersFactory.makeParameters(from: ticker)
                    AnalyticsService.shared.trackRefreshedTicker(parameters: analyticsParameters)
                
                    self?.fetchingTickerPropertiesError = nil
                
                case .failure(let error):
                    self?.fetchingTickerPropertiesError = error
            }
        }
    }
    
    func refreshTickersIdentifiers() {
        if let lastSuccesfullyTickersIdentifiersFetchedDate = lastSuccesfullyTickersIdentifiersFetchedDate, Date().timeIntervalSince(lastSuccesfullyTickersIdentifiersFetchedDate) < AppConfiguration.UserData.minimumTimeSpanBetweenTickerIndentifiersRefreshes {
            return
        }
        
        tickerIdentifiersFetcher.fetch { [weak self] result in
            switch result {
                case .success(let tickersIdentifiers):
                    TickerIdentifiersStore.shared.tickerIdentifiers = tickersIdentifiers
                
                    let tickerIdentifiersOfUserTickers = self?.tickers.map { TickerIdentifier(id: $0.id) } ?? []
                    
                    self?.tickersIdentifiersAvailableToAdd = tickersIdentifiers.filter { tickerIdentifiersOfUserTickers.contains($0) == false }
                
                    self?.lastSuccesfullyTickersIdentifiersFetchedDate = Date()
                
                    self?.fetchingTickerIdentifiersError = nil
                case .failure(let error):
                    self?.fetchingTickerIdentifiersError = error
            }
        }
    }
    
}
