protocol MainLocalDataModel {
    
    var supportedTickers: [SupportedTicker] { get }
    var currencies: Set<Currency> { get }
    var tickers: [Ticker] { get }
    
}

struct MainLocalDataFetchedModel: MainLocalDataModel, Codable {
    
    let supportedTickers: [SupportedTicker]
    let currencies: Set<Currency>
    let tickers: [Ticker]
    
}

struct DefaultMainLocalDataFetcherModel: MainLocalDataModel {
    
    let supportedTickers: [SupportedTicker] = [
        SupportedTicker(identifier: "btc-pln"),
        SupportedTicker(identifier: "eth-pln"),
        SupportedTicker(identifier: "lsk-usd"),
        SupportedTicker(identifier: "btc-eur"),
        SupportedTicker(identifier: "lsk-pln")
    ]
    
    let currencies: Set<Currency> = [
        Currency(code: "btc", name: "Bitcoin", minimumOffer: nil, scale: nil),
        Currency(code: "eth", name: "Ethereum", minimumOffer: nil, scale: nil),
        Currency(code: "lsk", name: "Lisk", minimumOffer: nil, scale: nil),
        Currency(code: "usd", name: "Dolar amerykański", minimumOffer: nil, scale: nil),
        Currency(code: "eur", name: "Euro", minimumOffer: nil, scale: nil),
        Currency(code: "pln", name: "Polski złoty", minimumOffer: nil, scale: nil)
    ]
    
    let tickers: [Ticker] = [
        Ticker(identifier: "btc-pln",
               highestBid: nil,
               lowestAsk: nil,
               rate: 111222333.11,
               previousRate: nil,
               highestRate: nil,
               lowestRate: nil,
               volume: nil,
               average: nil),
        Ticker(identifier: "eth-pln",
               highestBid: nil,
               lowestAsk: nil,
               rate: 222333.44,
               previousRate: nil,
               highestRate: nil,
               lowestRate: nil,
               volume: nil,
               average: nil),
        Ticker(identifier: "lsk-usd",
               highestBid: nil,
               lowestAsk: nil,
               rate: 3334.55,
               previousRate: nil,
               highestRate: 2233.44,
               lowestRate: nil,
               volume: nil,
               average: nil)
    ]
    
}
