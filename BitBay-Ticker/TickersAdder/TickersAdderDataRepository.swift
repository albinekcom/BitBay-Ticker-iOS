final class TickersAdderDataRepository: TickersAdderDataRepositoryProtocol {
    
    weak var delegate: TickersAdderDataRepositoryDelegate?
    
    private let externalDataRepository: (TickersDataRepositoryProtocol & CurrenciesDataRepositoryProtocol & SupportedTickersDataRepositoryProtocol & TickersAppendableDataRepositoryProtocol)
    
    private(set) var model: TickersAdderModel = TickersAdderModel(tickers: [])
    
    init(externalDataRepository: (TickersDataRepositoryProtocol & CurrenciesDataRepositoryProtocol & SupportedTickersDataRepositoryProtocol & TickersAppendableDataRepositoryProtocol)) {
        self.externalDataRepository = externalDataRepository
        
        externalDataRepository.tickersDataDelegate = self
        externalDataRepository.currenciesDataDelegate = self
        externalDataRepository.supportedTickersDataDelegate = self
        
        updateModel()
    }
    
    func appendNewTicker(tickerIdentifier: String) {
        externalDataRepository.appendNewTicker(with: tickerIdentifier)
    }
    
    private func updateModel() { // NOTE: Make this method nicer
        var tickersOnAdderData: [TickerOnAdderData] = []
        
        for supportedTicker in externalDataRepository.supportedTickers {
            guard let firstCurrencyCode = supportedTicker.firstCurrencyCode else { continue }
            guard let secondCurrencyCode = supportedTicker.secondCurrencyCode else { continue }
            
            var tags: [String] = [firstCurrencyCode, secondCurrencyCode]
            
            if let firstCurrency = Array(externalDataRepository.currencies).filter({ $0.code == firstCurrencyCode }).first, let firstCurrencyName = firstCurrency.name {
                tags.append(firstCurrencyName)
            }
            
            if let secondCurrency = Array(externalDataRepository.currencies).filter({ $0.code == secondCurrencyCode }).first, let secondCurrencyName = secondCurrency.name {
                tags.append(secondCurrencyName)
            }
            
            tags.append(firstCurrencyCode)
            
            if externalDataRepository.tickers.contains(where: {$0.identifier == supportedTicker.identifier}) == false {
                let tickerOnAdderData = TickerOnAdderData(tickerIdentifier: supportedTicker.identifier, firstCurrencyCode: firstCurrencyCode, secondCurrencyCode: secondCurrencyCode, tags: tags)
                
                tickersOnAdderData.append(tickerOnAdderData)
            }
        }
        
        model = TickersAdderModel(tickers: tickersOnAdderData)
        
        delegate?.didFetchNewModel()
    }
    
}

extension TickersAdderDataRepository: (TickersDataRepositoryDelegate & CurrenciesDataRepositoryDelegate & SupportedTickersDataRepositoryDelegate) {
    
    func didUpdateTickers(error: Error?) {
        updateModel()
    }
    
    func didUpdateCurrencies() {
        updateModel()
    }
    
    func didUpdateSupportedTickers() {
        updateModel()
    }
    
}

// Protocols

protocol TickersAdderDataRepositoryProtocol: AnyObject {
    
    var delegate: TickersAdderDataRepositoryDelegate? { get set }
    
    var model: TickersAdderModel { get }
    
    func appendNewTicker(tickerIdentifier: String)
}

protocol TickersAdderDataRepositoryDelegate: AnyObject {
    
    func didFetchNewModel()
    
}
