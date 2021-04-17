struct SupportedTicker: Codable, Equatable, TickerIdentifierComponents {
    
    let identifier: String
    
}

//

protocol TickerIdentifierComponents {
    
    var identifier: String { get }
    
    var firstCurrencyCode: String? { get }
    var secondCurrencyCode: String? { get }
    
}

extension TickerIdentifierComponents {
    
    var firstCurrencyCode: String? {
        currencyIdentifiers?.first
    }
    
    var secondCurrencyCode: String? {
        currencyIdentifiers?.last
    }
    
    private var currencyIdentifiers: [String]? {
        let seperatedComponents = identifier.components(separatedBy: "-")
        
        if seperatedComponents.count == 2 {
            return seperatedComponents
        } else {
            return nil
        }
    }
    
}
