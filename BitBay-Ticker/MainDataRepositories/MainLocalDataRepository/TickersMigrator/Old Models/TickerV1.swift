import Foundation

struct TickerV1: Codable, Equatable, Identifiable {
    
    struct Currency: Codable, Equatable {
        
        var currency: String?
        var minimumOffer: Double?
        var scale: Int?
        
    }
    
    let id: String
    
    let firstCurrency: Currency?
    let secondCurrency: Currency?
    let highestBid: Double?
    let lowestAsk: Double?
    let rate: Double?
    let previousRate: Double?
    let highestRate: Double?
    let lowestRate: Double?
    let volume: Double?
    let average: Double?
    
    init(id: String,
         firstCurrency: Currency? = nil,
         secondCurrency: Currency? = nil,
         highestBid: Double? = nil,
         lowestAsk: Double? = nil,
         rate: Double? = nil,
         previousRate: Double? = nil,
         highestRate: Double? = nil,
         lowestRate: Double? = nil,
         volume: Double? = nil,
         average: Double? = nil) {
        self.id = id
        self.firstCurrency = firstCurrency
        self.secondCurrency = secondCurrency
        self.highestBid = highestBid
        self.lowestAsk = lowestAsk
        self.rate = rate
        self.previousRate = previousRate
        self.highestRate = highestRate
        self.lowestRate = lowestRate
        self.volume = volume
        self.average = average
    }
    
}

extension TickerV1 {
    
    func convertToCurrentTicker() -> Ticker {
        Ticker(identifier: id.lowercased(),
               highestBid: highestBid,
               lowestAsk: lowestAsk,
               rate: rate,
               previousRate: previousRate,
               highestRate: highestRate,
               lowestRate: lowestRate,
               volume: volume,
               average: average)
    }
    
}
