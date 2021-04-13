import Foundation

enum FetchingSource {
    
    case automatic
    case automaticAfterAddingTicker
    case widget
    
}

struct TickersFetcherModel {
    
    let tickers: [Ticker]
    let externalCurrenciesProperties: [String: ExternalCurrencyProperties]
    
}
/*
final class TickersFetcher {
    
    private var miltipleTickerFetchers: [TickerFetcher] = []
    private var singleTickerFetcher: TickerFetcher = TickerFetcher()
    
    private(set) var dispatchGroup = DispatchGroup()
    
    var isSucessfulyRefreshedMultipleTickers = false
    
    func fetchTickers(tickerIdentifiers: [String], source: FetchingSource, completion: @escaping ((Result<TickersFetcherModel, TickerPropertiesFetcherError>) -> Void)) {
        
        if source == .automatic {
            fetchMultipleTickers(tickersIdentifiers: tickerIdentifiers,
                                 source: .automatic) { result in
                completion(result)
            }
        } else if source == .automaticAfterAddingTicker, let tickerIdentifier = tickerIdentifiers.first {
            fetchSingleTicker(tickerIdentifier: tickerIdentifier, source: .automaticAfterAddingTicker) { result in
                completion(result)
            }
        } else {
            completion(.failure(.genericError))
        }
        
    }
    
    private func fetchMultipleTickers(tickersIdentifiers: [String], source: FetchingSource, completion: @escaping (Result<([Ticker], Set<ExternalCurrencyProperties>), TickerPropertiesFetcherError>) -> Void) {
        
        miltipleTickerFetchers.forEach { $0.cancelFetchingTicker() }
        
        miltipleTickerFetchers = tickersIdentifiers.map { _ in TickerFetcher() }
        
        dispatchGroup = DispatchGroup()
        
        isSucessfulyRefreshedMultipleTickers = false
        
        miltipleTickerFetchers.forEach { _ in
            dispatchGroup.enter()
        }
        
        dispatchGroup.notify(queue: .main) {
            
        }
        
    }
    
    private func fetchSingleTicker(tickerIdentifier: String, source: FetchingSource, completion: @escaping ((Result<(Ticker, Set<ExternalCurrencyProperties>), TickerPropertiesFetcherError>) -> Void)) {
        
    }
    
}
*/
