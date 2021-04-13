struct SupportedTickersAndCurrenciesNamesFetcherModel {
    
    let supportedTickers: [SupportedTicker]
    let currenciesNames: [String: String]
    
    init(supportedTickersAPIResponse: SupportedTickersAndCurrenciesNamesFetcherAPIResponse) {
        supportedTickers = supportedTickersAPIResponse.supportedTickers?.map { SupportedTicker(identifier: $0) } ?? []
        currenciesNames = supportedTickersAPIResponse.names ?? [:]
    }
    
}
