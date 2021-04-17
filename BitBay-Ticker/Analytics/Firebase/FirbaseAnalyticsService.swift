import Firebase

enum FirbaseAnalyticsTrackName: String {
    
    case addTickerView = "Add_Ticker_View"
    case tickersView = "Tickers_View"
    case tickerDetailsView = "Ticker_Details_View"
    case editTickersView = "Edit_Tickers_View"
    case requestedRatingView = "Requested_Rating_View"
    
    case addedTicker = "Added_Ticker"
    case removedTicker = "Removed_Ticker"
    case refreshedTickers = "Refreshed_Tickers"
    case refreshingTickersFailed = "Refreshing_Tickers_Failed"
    
}

final class FirbaseAnalyticsService: AnalyticsService {
    
    static let shared = FirbaseAnalyticsService()
    
    init(firebaseApp: FirebaseApp.Type, firebaseAnalytics: Analytics.Type) {
        self.firebaseAnalytics = LocalConsoleAnalytics.self
        
        firebaseApp.configure()
    }
    
    private let firebaseAnalytics: Analytics.Type
    
    private convenience init() {
        self.init(firebaseApp: FirebaseApp.self, firebaseAnalytics: Analytics.self)
    }
    
    // MARK: - Views
    
    func trackDisplayedTickersAdderView() {
        track(trackName: .addTickerView)
    }
    
    func trackDisplayedTickersListView() {
        track(trackName: .tickersView)
    }
    
    func trackDisplayedTickerDetailsView(tickerIdentifier: String) {
        let parameters = [
            AnalyticsParameterValue.firebaseParameterValue(from: tickerIdentifier)
        ]
        
        track(trackName: .tickerDetailsView,
              parameters: parameters)
    }
    
    func trackDisplayedTickersListViewInEditMode() {
        track(trackName: .editTickersView)
    }
    
    func trackRequstedRatingView() {
        track(trackName: .requestedRatingView)
    }
    
    // MARK: - Actions
    
    func trackAddedTicker(tickerIdentifier: String) {
        let parameters = [
            AnalyticsParameterValue.firebaseParameterValue(from: tickerIdentifier)
        ]
        
        track(trackName: .addedTicker,
              parameters: parameters)
    }
    
    func trackRemovedTicker(tickerIdentifier: String) {
        let parameters = [
            AnalyticsParameterValue.firebaseParameterValue(from: tickerIdentifier)
        ]
        
        track(trackName: .removedTicker,
              parameters: parameters)
    }
    
    func trackRefreshedTickers(tickerIdentifiers: [String], source: AnalyticsFetchingSource) {
        let parameters = [
            AnalyticsParameterValue.firebaseParameterValue(from: tickerIdentifiers),
            AnalyticsParameterValue.firebaseParameterValue(from: source)
        ]
        
        track(trackName: .refreshedTickers,
              parameters: parameters)
    }
    
    func trackRefreshingTickersFailed(source: AnalyticsFetchingSource) {
        let parameters = [
            AnalyticsParameterValue.firebaseParameterValue(from: source)
        ]
        
        track(trackName: .refreshingTickersFailed,
              parameters: parameters)
    }
    
    // MARK: - Track
    
    private func track(trackName: FirbaseAnalyticsTrackName, parameters: [AnalyticsParameterValue]? = nil) {
        firebaseAnalytics.logEvent(trackName.rawValue,
                                   parameters: parameters?.dictionary)
    }
    
}
