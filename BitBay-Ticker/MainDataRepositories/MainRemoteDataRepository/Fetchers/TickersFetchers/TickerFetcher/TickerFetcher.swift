import Foundation

enum TickerFetcherError: Error {
    
    case genericError
    
}

final class TickerFetcher {
    
    private let tickerPropertiesFetcher: TickerPropertiesFetcher
    
    init(tickerPropertiesFetcher: TickerPropertiesFetcher = TickerPropertiesFetcher()) {
        self.tickerPropertiesFetcher = tickerPropertiesFetcher
    }
    
    func fetchTicker(tickerIdentifier: String, completion: @escaping ((Result<(Ticker, ExternalCurrenciesProperties), TickerFetcherError>) -> Void)) {
        tickerPropertiesFetcher.fetchValues(tickerIdentifier: tickerIdentifier) { [weak self] fetchedValuesResult in
            guard let self = self else {
                completion(.failure(.genericError))
                
                return
            }
            
            switch fetchedValuesResult {
            case let .success((tickerValues, externalCurrenciesProperties)):
                self.tickerPropertiesFetcher.fetchStatistics(tickerIdentifier: tickerIdentifier) { fetchedStatisticsResult in
                    switch fetchedStatisticsResult {
                    case .success(let tickerStatistics):
                        let ticker = Ticker(identifier: tickerIdentifier, tickerValues: tickerValues, tickerStatistics: tickerStatistics)
                        
                        completion(.success((ticker, externalCurrenciesProperties)))
                        
                    case .failure:
                        completion(.failure(.genericError))
                    }
                }
                
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
    
    func cancelFetchingTicker() {
        tickerPropertiesFetcher.cancelFetching()
    }
    
}
