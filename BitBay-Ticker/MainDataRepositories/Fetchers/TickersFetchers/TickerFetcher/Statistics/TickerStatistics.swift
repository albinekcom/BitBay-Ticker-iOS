struct TickerStatistics {
    
    let highestRate: Double?
    let lowestRate: Double?
    let volume: Double?
    let average: Double?
    
    init(tickerStatisticsAPIResponse: TickerStatisticsAPIResponse) {
        highestRate = Double(tickerStatisticsAPIResponse.stats?.h)
        lowestRate = Double(tickerStatisticsAPIResponse.stats?.l)
        volume = Double(tickerStatisticsAPIResponse.stats?.v)
        average = Double(tickerStatisticsAPIResponse.stats?.r24h)
    }
    
}
