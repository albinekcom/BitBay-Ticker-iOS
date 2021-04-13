import Foundation

struct Endpoint {
    
    let path: String
    
}

extension Endpoint {
    
    static func tickerValues(tickerIdentifier: String) -> Endpoint {
        Endpoint(path: "https://api.bitbay.net/rest/trading/ticker/\(tickerIdentifier)")
    }
    
    static func tickerStatistics(tickerIdentifier: String) -> Endpoint {
        Endpoint(path: "https://api.bitbay.net/rest/trading/stats/\(tickerIdentifier)")
    }
    
    static let supportedTickersAndCurrenciesNames: Endpoint = Endpoint(path: "https://raw.githubusercontent.com/albinekcom/BitBay-API-Tools/master/v1/supported-tickers.json")
    
}

extension Endpoint {
    
    var url: URL? {
        return URL(string: path)
    }
    
}
