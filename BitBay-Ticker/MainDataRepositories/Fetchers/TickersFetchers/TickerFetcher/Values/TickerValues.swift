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

// NOTE: Move the below struct

struct ExternalCurrencyProperties {
    
    let currencyCode: String
    let scale: Int?
    
}

extension ExternalCurrencyProperties {
    
    init?(currencyAPIReponse: TickerValuesAPIResponse.TickerAPIResponse.MarketAPIResponse.CurrencyAPIReponse?) {
        guard let currencyAPIReponseCurrency = currencyAPIReponse?.currency else { return nil }
        
        self.currencyCode = currencyAPIReponseCurrency
        self.scale = currencyAPIReponse?.scale
    }
    
}
