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
