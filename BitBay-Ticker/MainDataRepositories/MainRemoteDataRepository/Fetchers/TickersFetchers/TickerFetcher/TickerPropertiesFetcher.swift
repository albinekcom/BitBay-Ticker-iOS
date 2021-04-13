import Foundation

enum TickerPropertiesFetcherError: Error {
    
    case parsingError
    case genericError
    
}

final class TickerAndExternalCurrenciesPropertiesFetcher {
    
    private let networkingServiceForValues: NetworkingService
    private let networkingServiceForStatistics: NetworkingService
    private let jsonDecoder: JSONDecoder
    
    init(networkingServiceForValues: NetworkingService = NetworkingService(),
         networkingServiceForStatistics: NetworkingService = NetworkingService(),
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.networkingServiceForValues = networkingServiceForValues
        self.networkingServiceForStatistics = networkingServiceForStatistics
        self.jsonDecoder = jsonDecoder
    }
    
    func fetchTickersAndExternalCurrenciesProperties(tickerIdentifier: String,
                                                     completion: @escaping ((Result<String, TickerPropertiesFetcherError>) -> Void)) { // NOTE: Fill this method wihich invokes the methods below
        
    }
    
    private func fetchValues(tickerIdentifier: String, completion: @escaping ((Result<(TickerValues, ExternalCurrenciesProperties), TickerPropertiesFetcherError>) -> Void)) {
        networkingServiceForValues.request(.tickerValues(tickerIdentifier: tickerIdentifier)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let tickerValuesAPIResponse = try? self?.jsonDecoder.decode(TickerValuesAPIResponse.self, from: data) else {
                    completion(.failure(.parsingError))

                    return
                }
                
                let tickerValues = TickerValues(identifier: tickerIdentifier, tickerValuesAPIResponse: tickerValuesAPIResponse)
                
                let firstExtenalCurrencyProperties = ExternalCurrencyProperties(currencyAPIReponse: tickerValuesAPIResponse.ticker?.market?.first)
                let secondExtenalCurrencyProperties = ExternalCurrencyProperties(currencyAPIReponse: tickerValuesAPIResponse.ticker?.market?.second)
                
                let externalCurrenciesProperties = ExternalCurrenciesProperties(firstExternalCurrencyProperties: firstExtenalCurrencyProperties,
                                                     secondExternalCurrencyProperties: secondExtenalCurrencyProperties)
                
                completion(.success((tickerValues, externalCurrenciesProperties)))
                
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
    
    private func fetchStatistics(tickerIdentifier: String, completion: @escaping ((Result<TickerStatistics, TickerPropertiesFetcherError>) -> Void)) {
        networkingServiceForStatistics.request(.tickerStatistics(tickerIdentifier: tickerIdentifier)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let tickerStatisticsAPIResponse = try? self?.jsonDecoder.decode(TickerStatisticsAPIResponse.self, from: data) else {
                    completion(.failure(.parsingError))

                    return
                }
                
                completion(.success(TickerStatistics(identifier: tickerIdentifier, tickerStatisticsAPIResponse: tickerStatisticsAPIResponse)))
                
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
    
    func cancelFetching() {
        cancelFetchingValues()
        cancelFetchingStatistics()
    }
    
    private func cancelFetchingValues() {
        networkingServiceForValues.cancelRequest()
    }
    
    private func cancelFetchingStatistics() {
        networkingServiceForStatistics.cancelRequest()
    }
    
}
