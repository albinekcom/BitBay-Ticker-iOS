struct TickerValuesAPIResponse: Codable {
    
    let status: String?
    let ticker: TickerAPIResponse?
    
    struct TickerAPIResponse: Codable {
        
        let market: MarketAPIResponse?
        let time: String?
        let highestBid: String?
        let lowestAsk: String?
        let rate: String?
        let previousRate: String?
        
        struct MarketAPIResponse: Codable {
            
            let code: String?
            let first: CurrencyAPIReponse?
            let second: CurrencyAPIReponse?
            
            struct CurrencyAPIReponse: Codable {
                
                let currency: String?
                let minOffer: String?
                let scale: Int?
                
            }
            
        }
        
    }
    
}
