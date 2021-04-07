protocol AnalyticsService: TickersListAnalyticsService,
                           TickerDetailsAnalyticsService,
                           RatingViewAnalyticsService,
                           TickersAdderAnalyticsService,
                           TickersFetcherAnalyticsService {}

protocol TickersListAnalyticsService: AnyObject {
    
    func trackDisplayedTickersListView()
    func trackDisplayedTickersListViewInEditMode()
    func trackRemovedTicker(tickerIdentifier: String)
}

protocol TickerDetailsAnalyticsService: AnyObject {
    
    func trackDisplayedTickerDetailsView(tickerIdentifier: String)
}

protocol RatingViewAnalyticsService: AnyObject {
    
    func trackRequstedRatingView()
}

protocol TickersAdderAnalyticsService: AnyObject {
    
    func trackDisplayedTickersAdderView()
    func trackAddedTicker(tickerIdentifier: String)
}

protocol TickersFetcherAnalyticsService: AnyObject {
    
    func trackRefreshedTickers(tickerIdentifiers: [String], source: AnalyticsFetchingSource)
    func trackRefreshingTickersFailed(source: AnalyticsFetchingSource)
}