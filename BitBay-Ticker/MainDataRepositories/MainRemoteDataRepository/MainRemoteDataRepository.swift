import Foundation

struct MainRemoteDataModel {
    
    let supportedTickers: [SupportedTicker]?
    let currencies: [String: Currency]
    let tickers: [String: Ticker]
    
}

final class MainRemoteDataRepository {
    
    private let supportedTickersAndCurrenciesNamesFetcher: SupportedTickersAndCurrenciesNamesFetcher
    private let tickerAndExternalCurrenciesPropertiesFetcher: TickerAndExternalCurrenciesPropertiesFetcher
    
    init(supportedTickersAndCurrenciesNamesFetcher: SupportedTickersAndCurrenciesNamesFetcher = SupportedTickersAndCurrenciesNamesFetcher(),
         tickerAndExternalCurrenciesPropertiesFetcher: TickerAndExternalCurrenciesPropertiesFetcher = TickerAndExternalCurrenciesPropertiesFetcher()) {
        self.supportedTickersAndCurrenciesNamesFetcher = supportedTickersAndCurrenciesNamesFetcher
        self.tickerAndExternalCurrenciesPropertiesFetcher = tickerAndExternalCurrenciesPropertiesFetcher
    }
    
    func fetchRemoteData(tickerIdentifiers: [String], completion: @escaping (MainRemoteDataModel) -> Void) {
        // NOTE: Finish combining values into "MainRemoteDataModel"
        
        var supportedTickers: [SupportedTicker]?
        var currenciesNames: [String: String] = [:]
        
        fetchRemoteSupportedTickersAndCurrenciesNames() { result in
            supportedTickers = result.0
            currenciesNames = result.1
        }
        
        let mainRemoteDataModel = MainRemoteDataModel(supportedTickers: supportedTickers,
                                                      currencies: [:],
                                                      tickers: [:])
        
        DispatchQueue.main.async {
            completion(mainRemoteDataModel)
        }
    }
    
    private func fetchRemoteSupportedTickersAndCurrenciesNames(completion: @escaping (([SupportedTicker]?, [String: String])) -> Void) {
        var supportedTickers: [SupportedTicker]?
        var names: [String: String] = [:]
        
        supportedTickersAndCurrenciesNamesFetcher.fetchSupportedTickersAndCurrenciesNames() { result in
            switch result {
            case .success(let values):
                supportedTickers = values.supportedTickers
                names = values.currenciesNames
                
            case .failure:
                break
            }
        }
        
        completion((supportedTickers, names))
    }
    
    private func fetchRemoteTickerValues(tickerIdentifier: String, completion: @escaping ((TickerValues?, [String: ExternalCurrencyProperties])) -> Void) {
        var tickerValues: TickerValues?
        var externalCurrencyPropertiesResults: [String: ExternalCurrencyProperties] = [:]
        
        tickerPropertiesFetcher.fetchValues(tickerIdentifier: tickerIdentifier) { result in
            switch result {
            case .success(let values):
                tickerValues = values.0
                
                if let firstExternalCurrencyProperties = values.1.firstExternalCurrencyProperties {
                    externalCurrencyPropertiesResults[firstExternalCurrencyProperties.currencyCode] = firstExternalCurrencyProperties
                }
                
                if let secondExternalCurrencyProperties = values.1.secondExternalCurrencyProperties {
                    externalCurrencyPropertiesResults[secondExternalCurrencyProperties.currencyCode] = secondExternalCurrencyProperties
                }
                
            case .failure:
                print("failure")
            }
        }
        
        completion((tickerValues, externalCurrencyPropertiesResults))
    }
    
    private func fetchRemoteTickerStatistics(tickerIdentifier: String, completion: @escaping (TickerStatistics?) -> Void) {
        var tickerStatistics: TickerStatistics?
        
        tickerPropertiesFetcher.fetchStatistics(tickerIdentifier: tickerIdentifier) { result in
            switch result {
            case .success(let values):
                tickerStatistics = values
                
            case .failure:
                print("failure")
            }
        }
        
        completion(tickerStatistics)
    }
    
}
