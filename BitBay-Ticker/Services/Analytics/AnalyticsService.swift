import Firebase

final class AnalyticsService {
    
    static let shared: AnalyticsService = AnalyticsService()
    
    init() {
        FirebaseApp.configure()
    }
    
    // MARK: - States
    
    func trackAddTickerView() {
        track(name: "Add_Ticker_View")
    }
    
    func trackTickersView() {
        track(name: "Tickers_View")
    }
    
    func trackTickerDetailsView(parameters: [String: String]) {
        track(name: "Ticker_Details_View", parameters: parameters)
    }
    
    func trackRequestedRatingView() {
        track(name: "Requested_Rating_View")
    }
    
    // MARK: - Actions
    
    func trackAddedTicker(parameters: [String: String]) {
        track(name: "Added_Ticker", parameters: parameters)
    }
    
    func trackRemovedTicker(parameters: [String: String]) {
        track(name: "Removed_Ticker", parameters: parameters)
    }
    
    func trackStartRefreshingTickers(parameters: [String: String]) {
        track(name: "Start_Refreshing_Tickers", parameters: parameters)
    }
    
    func trackRefreshedTicker(parameters: [String: String]) {
        track(name: "Refreshed_Ticker", parameters: parameters)
    }
    
    // MARK: - Tracking
    
    private func track(name: String, parameters: [String: String]? = nil) {
        trackIfEnabled(name: name, parameters: parameters)
        printConsoleLogIfEnabled(name: name, parameters: parameters)
    }
    
    private func trackIfEnabled(name: String, parameters: [String: String]? = nil) {
        guard AppConfiguration.Analytics.isTrackingEnabled else { return }
        
        Analytics.logEvent(name, parameters: parameters)
    }
    
    private func printConsoleLogIfEnabled(name: String, parameters: [String: String]? = nil) {
        guard AppConfiguration.Analytics.shouldPrintConsoleLog else { return }
        
        var description = "👣 [TRACKED] \"\(name)\""
        
        if let parameters = parameters {
            description += " with parameters: \(String(describing: parameters))"
        }
        
        print(description)
    }
    
}
