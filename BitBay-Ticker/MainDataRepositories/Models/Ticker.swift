struct Ticker: Codable, TickerIdentifierComponents {
    
    let identifier: String
    
    let highestBid: Double?
    let lowestAsk: Double?
    let rate: Double?
    let previousRate: Double?
    let highestRate: Double?
    let lowestRate: Double?
    let volume: Double?
    let average: Double?
    
}

extension Ticker {
    
    init(identifier: String, tickerValues: TickerValues? = nil, tickerStatistics: TickerStatistics? = nil) {
        self.identifier = identifier
        
        highestBid = tickerValues?.highestBid
        lowestAsk = tickerValues?.lowestAsk
        rate = tickerValues?.rate
        previousRate = tickerValues?.previousRate
        highestRate = tickerStatistics?.highestRate
        lowestRate = tickerStatistics?.lowestRate
        volume = tickerStatistics?.volume
        average = tickerStatistics?.average
    }
    
}
