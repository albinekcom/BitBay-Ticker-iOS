protocol MainLocalDataModel {
    
    var supportedTickers: [SupportedTicker] { get }
    var currencies: [String: Currency] { get }
    var userTickers: [Ticker] { get }
    
}

struct MainLocalDataFetchedModel: MainLocalDataModel, Codable {
    
    let supportedTickers: [SupportedTicker]
    let currencies: [String: Currency]
    let userTickers: [Ticker]
    
}

struct DefaultMainLocalDataFetcherModel: MainLocalDataModel {
    
    let supportedTickers: [SupportedTicker] = [
        SupportedTicker(identifier: "BTC-PLM"),
        SupportedTicker(identifier: "ETH-PLN"),
        SupportedTicker(identifier: "LSK-USD"),
        SupportedTicker(identifier: "BTC-EUR"),
        SupportedTicker(identifier: "LSK-PLN")
    ]
    
    let currencies: [String: Currency] = [
        "BTC": Currency(code: "BTC", name: "Bitcoin", scale: 8),
        "ETH": Currency(code: "ETH", name: "Ethereum", scale: 8),
        "LSK": Currency(code: "LSK", name: "Lisk", scale: 8),
        "USD": Currency(code: "USD", name: "Dolar amerykański", scale: 2),
        "EUR": Currency(code: "EUR", name: "Euro", scale: 2),
        "PLN": Currency(code: "PLN", name: "Polski złoty", scale: 2)
    ]
    
    let userTickers: [Ticker] = [
        Ticker(identifier: "BTC-PLN"),
        Ticker(identifier: "ETH-PLN"),
        Ticker(identifier: "LSK-USD")
    ]
    
}
