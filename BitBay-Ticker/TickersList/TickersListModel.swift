struct TickersListModel {
    
    let tickers: [TickerOnListData]
    
}

struct TickerOnListData {
    
    let tickerIdentifier: String
    
    let firstCurrencyCode: String
    let secondCurrencyCode: String
    let secondCurrencyScale: Int?
    
    let rate: Double?
    
}
