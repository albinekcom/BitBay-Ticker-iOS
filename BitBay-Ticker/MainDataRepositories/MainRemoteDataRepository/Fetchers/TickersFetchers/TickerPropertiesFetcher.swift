import Foundation

enum TickerPropertiesFetcherError: Error {
    
    case parsingError
    case genericError
    case canceled
    
}

struct TickerAndExternalCurrenciesPropertiesModel {
    
    let ticker: Ticker
    let externalCurrenciesProperties: [String: ExternalCurrencyProperties]
    
}

final class TickerAndExternalCurrenciesPropertiesFetcher {
    
    private let tickerIdentifier: String
    
    private let networkingServiceForValues: NetworkingService
    private let networkingServiceForStatistics: NetworkingService
    private let jsonDecoder: JSONDecoder
    
    private var dispatchGroup: DispatchGroup = DispatchGroup()
    
    private var completion: ((Result<TickerAndExternalCurrenciesPropertiesModel, TickerPropertiesFetcherError>) -> Void)?
    
    init(tickerIdentifier: String,
         networkingServiceForValues: NetworkingService = NetworkingService(),
         networkingServiceForStatistics: NetworkingService = NetworkingService(),
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.tickerIdentifier = tickerIdentifier
        self.networkingServiceForValues = networkingServiceForValues
        self.networkingServiceForStatistics = networkingServiceForStatistics
        self.jsonDecoder = jsonDecoder
    }
    
    func fetchTickersAndExternalCurrenciesProperties(completion: ((Result<TickerAndExternalCurrenciesPropertiesModel, TickerPropertiesFetcherError>) -> Void)?) {
        self.completion = completion
        let tickerIdentifier = self.tickerIdentifier
        
        var tickerValues: TickerValues?
        var tickerStatistics: TickerStatistics?
        var externalCurrenciesProperties: [String: ExternalCurrencyProperties] = [:]
        
        dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        networkingServiceForValues.request(.tickerValues(tickerIdentifier: tickerIdentifier)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let tickerValuesAPIResponse = try? self?.jsonDecoder.decode(TickerValuesAPIResponse.self, from: data) else {
                    self?.completion?(.failure(.parsingError))
                    self?.completion = nil

                    return
                }
                
                tickerValues = TickerValues(identifier: tickerIdentifier, tickerValuesAPIResponse: tickerValuesAPIResponse)
                
                if let firstExtenalCurrencyProperties = ExternalCurrencyProperties(currencyAPIReponse: tickerValuesAPIResponse.ticker?.market?.first) {
                    externalCurrenciesProperties[firstExtenalCurrencyProperties.currencyCode] = firstExtenalCurrencyProperties
                }
                
                if let secondExtenalCurrencyProperties = ExternalCurrencyProperties(currencyAPIReponse: tickerValuesAPIResponse.ticker?.market?.second) {
                    externalCurrenciesProperties[secondExtenalCurrencyProperties.currencyCode] = secondExtenalCurrencyProperties
                }
            case .failure:
                self?.completion?(.failure(.genericError))
                self?.completion = nil
            }
            
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        
        networkingServiceForStatistics.request(.tickerStatistics(tickerIdentifier: tickerIdentifier)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let tickerStatisticsAPIResponse = try? self?.jsonDecoder.decode(TickerStatisticsAPIResponse.self, from: data) else {
                    self?.completion?(.failure(.parsingError))
                    self?.completion = nil

                    return
                }
                
                tickerStatistics = TickerStatistics(identifier: tickerIdentifier, tickerStatisticsAPIResponse: tickerStatisticsAPIResponse)
                
            case .failure:
                self?.completion?(.failure(.genericError))
                self?.completion = nil
            }
            
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global(qos: .utility)) { [weak self] in
            let ticker = Ticker(identifier: tickerIdentifier, tickerValues: tickerValues, tickerStatistics: tickerStatistics)
            
            self?.completion?(.success(TickerAndExternalCurrenciesPropertiesModel(ticker: ticker,
                                                                                  externalCurrenciesProperties: externalCurrenciesProperties)))
            self?.completion = nil
        }
    }
    
    func cancelFetching() {
        networkingServiceForValues.cancelRequest()
        networkingServiceForStatistics.cancelRequest()
        
        dispatchGroup = DispatchGroup()
        
        completion?(.failure(.canceled))
        completion = nil
    }
    
}
