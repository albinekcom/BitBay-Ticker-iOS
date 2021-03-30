import Foundation

enum TickerFetcherError: Error {
    
    case genericError
    
}

final class TickerFetcher {
    
    private let tickerPropertiesFetcher: TickerPropertiesFetcher
    private let tickerIdentifier: String
    
    init(tickerIdentifier: String,
        tickerPropertiesFetcher: TickerPropertiesFetcher = TickerPropertiesFetcher()) {
        self.tickerIdentifier = tickerIdentifier
        self.tickerPropertiesFetcher = tickerPropertiesFetcher
    }
    
    func fetchTicker(completion: @escaping ((Result<(Ticker, ExternalCurrenciesProperties), TickerFetcherError>) -> Void)) {
        tickerPropertiesFetcher.fetchValues(tickerIdentifier: tickerIdentifier) { [weak self] fetchedValuesResult in
            guard let self = self else {
                completion(.failure(.genericError))
                
                return
            }
            
            switch fetchedValuesResult {
            case let .success((tickerValues, externalCurrenciesProperties)):
                self.tickerPropertiesFetcher.fetchStatistics(tickerIdentifier: self.tickerIdentifier) { fetchedStatisticsResult in
                    switch fetchedStatisticsResult {
                    case .success(let tickerStatistics):
                        let ticker = Ticker(identifier: self.tickerIdentifier, tickerValues: tickerValues, tickerStatistics: tickerStatistics)
                        
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
