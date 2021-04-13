struct TickerValues {
    
    let identifier: String
    
    let highestBid: Double?
    let lowestAsk: Double?
    let rate: Double?
    let previousRate: Double?
    
    init(identifier: String, tickerValuesAPIResponse: TickerValuesAPIResponse) {
        self.identifier = identifier
        
        highestBid = Double(tickerValuesAPIResponse.ticker?.highestBid)
        lowestAsk = Double(tickerValuesAPIResponse.ticker?.lowestAsk)
        rate = Double(tickerValuesAPIResponse.ticker?.rate)
        previousRate = Double(tickerValuesAPIResponse.ticker?.previousRate)
    }
    
}
