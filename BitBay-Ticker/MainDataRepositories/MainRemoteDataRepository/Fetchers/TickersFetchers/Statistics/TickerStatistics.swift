struct TickerStatistics {
    
    let identifier: String
    
    let highestRate: Double?
    let lowestRate: Double?
    let volume: Double?
    let average: Double?
    
    init(identifier: String, tickerStatisticsAPIResponse: TickerStatisticsAPIResponse) {
        self.identifier = identifier
        
        highestRate = Double(tickerStatisticsAPIResponse.stats?.h)
        lowestRate = Double(tickerStatisticsAPIResponse.stats?.l)
        volume = Double(tickerStatisticsAPIResponse.stats?.v)
        average = Double(tickerStatisticsAPIResponse.stats?.r24h)
    }
    
}
