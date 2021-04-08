struct SupportedTickersAndCurrenciesNamesFetcherModel {
    
    let supportedTickers: [SupportedTicker]
    let currencies: Set<Currency>
    
    init(supportedTickersAPIResponse: SupportedTickersAndCurrenciesNamesFetcherAPIResponse) {
        supportedTickers = supportedTickersAPIResponse.supportedTickers?.map { SupportedTicker(identifier: $0) } ?? []
        
        if let unwrappedNames = supportedTickersAPIResponse.names {
            currencies = Set(unwrappedNames.map { key, value in Currency(code: key, name: value, minimumOffer: nil, scale: nil) })
        } else {
            currencies = []
        }
    }
    
}
