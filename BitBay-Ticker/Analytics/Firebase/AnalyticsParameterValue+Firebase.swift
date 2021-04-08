extension AnalyticsParameterValue {
    
    static func firebaseParameterValue(from tickerIdentifier: String) -> AnalyticsParameterValue {
        AnalyticsParameterValue(key: "Ticker", value: tickerIdentifier)
    }
    
    static func firebaseParameterValue(from tickersIdentifiers: [String]) -> AnalyticsParameterValue {
        let value = tickersIdentifiers
            .joined(separator: ",")
        
        return AnalyticsParameterValue(key: "Tickers", value: value)
    }
    
    static func firebaseParameterValue(from source: AnalyticsFetchingSource) -> AnalyticsParameterValue {
        let value: String
        
        switch source {
        case .automatic:
            value = "Automatic"
            
        case .automaticAfterAddingTicker:
            value = "Automatic_after_adding_ticker"
            
        case .widget:
            value = "Widget"
        }
        
        return AnalyticsParameterValue(key: "Source", value: value)
    }
    
}

extension Array where Element == AnalyticsParameterValue {
    
    var dictionary: [String: String] {
        var dictionary: [String: String] = [:]
        
        forEach { dictionary[$0.key] = $0.value }
        
        return dictionary
    }
}
