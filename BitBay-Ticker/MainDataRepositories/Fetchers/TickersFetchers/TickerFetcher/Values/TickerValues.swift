struct TickerValues {
    
    let highestBid: Double?
    let lowestAsk: Double?
    let rate: Double?
    let previousRate: Double?
    
    init(tickerValuesAPIResponse: TickerValuesAPIResponse) {
        highestBid = Double(tickerValuesAPIResponse.ticker?.highestBid)
        lowestAsk = Double(tickerValuesAPIResponse.ticker?.lowestAsk)
        rate = Double(tickerValuesAPIResponse.ticker?.rate)
        previousRate = Double(tickerValuesAPIResponse.ticker?.previousRate)
    }
    
}
