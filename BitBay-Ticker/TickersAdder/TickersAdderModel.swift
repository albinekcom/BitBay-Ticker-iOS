struct TickersAdderModel {
    
    let tickers: [TickerOnAdderData]
    
}

struct TickerOnAdderData {
    
    let tickerIdentifier: String
    
    let firstCurrencyCode: String
    let secondCurrencyCode: String
    
    let tags: [String]
    
}

extension TickerOnAdderData {
    
    func isSearchTermInTags(searchTerm: String) -> Bool {
        for tag in tags {
            if tag.localizedCaseInsensitiveContains(searchTerm) {
                return true
            }
        }
        
        return false
    }
    
}
