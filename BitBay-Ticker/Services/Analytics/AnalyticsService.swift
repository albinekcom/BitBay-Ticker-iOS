import Firebase

final class AnalyticsService {
    
    enum Source: String {
        
        case automatic = "Automatic"
        case automaticAfterAddingTicker = "Automatic_after_adding_ticker"
        case widget = "Widget"
        
    }
    
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
    
    func trackEditTickersView() {
        track(name: "Edit_Tickers_View")
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
    
    func trackRefreshedTickers(parameters: [String: String], source: Source) {
        var updatedParameters = parameters
        updatedParameters["Source"] = source.rawValue
        
        track(name: "Refreshed_Tickers", parameters: updatedParameters)
    }
    
    func trackRefreshingTickersFailed(source: Source) {
        var parameters: [String: String] = [:]
        parameters["Source"] = source.rawValue
        
        track(name: "Refreshing_Tickers_Failed", parameters: parameters)
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
