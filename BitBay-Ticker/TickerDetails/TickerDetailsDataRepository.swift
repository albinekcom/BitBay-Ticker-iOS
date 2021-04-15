final class TickerDetailsDataRepository: TickerDetailsDataRepositoryProtocol {
    
    weak var delegate: TickerDetailsDataRepositoryDelegate?
    
    private let tickersAndCurrenciesDataRepository: (TickersDataRepositoryProtocol & CurrenciesDataRepositoryProtocol)
    
    let tickerIdentifier: String
    
    private(set) var model: TickerDetailsModel
    
    init(tickerIdentifier: String, tickersAndCurrenciesDataRepository: (TickersDataRepositoryProtocol & CurrenciesDataRepositoryProtocol)) {
        self.tickerIdentifier = tickerIdentifier
        self.tickersAndCurrenciesDataRepository = tickersAndCurrenciesDataRepository
        
        model = TickerDetailsModel(firstCurrencyCode: "",
                                  firstCurrencyName: "",
                                  secondCurrencyCode: "",
                                  secondCurrencyScale: nil,
                                  rate: nil,
                                  previousRate: nil,
                                  highestRate: nil,
                                  lowestRate: nil,
                                  highestBid: nil,
                                  lowestAsk: nil,
                                  average: nil,
                                  volume: nil)
        
        
        self.tickersAndCurrenciesDataRepository.tickersDataDelegate = self
        self.tickersAndCurrenciesDataRepository.currenciesDataDelegate = self
        
        updateModel()
    }
    
    private func updateModel() {
        guard let updatedTicker = tickersAndCurrenciesDataRepository.userTickers.filter({ $0.identifier == tickerIdentifier }).first else {
            delegate?.didFetchNewModel(isTickerStillSupported: false)
            
            return
        }
        
        let firstCurrency = Array(tickersAndCurrenciesDataRepository.currencies).filter { $0.code == updatedTicker.firstCurrencyCode }.first
        let secondCurrency = Array(tickersAndCurrenciesDataRepository.currencies).filter { $0.code == updatedTicker.secondCurrencyCode }.first
        
        let newModel = TickerDetailsModel(firstCurrencyCode: updatedTicker.firstCurrencyCode ?? "-",
                                          firstCurrencyName: firstCurrency?.name ?? "-",
                                          secondCurrencyCode: updatedTicker.secondCurrencyCode ?? "-",
                                          secondCurrencyScale: secondCurrency?.scale,
                                          rate: updatedTicker.rate,
                                          previousRate: updatedTicker.previousRate,
                                          highestRate: updatedTicker.highestRate,
                                          lowestRate: updatedTicker.lowestRate,
                                          highestBid: updatedTicker.highestBid,
                                          lowestAsk: updatedTicker.lowestAsk,
                                          average: updatedTicker.average,
                                          volume: updatedTicker.volume)
        
        model = newModel
        
        delegate?.didFetchNewModel(isTickerStillSupported: true)
    }
    
}

extension TickerDetailsDataRepository: (TickersDataRepositoryDelegate & CurrenciesDataRepositoryDelegate) {
    
    func didUpdateTickers(error: Error?) {
        updateModel()
    }
    
    func didUpdateCurrencies() {
        updateModel()
    }
    
}

//

protocol TickerDetailsDataRepositoryProtocol: AnyObject {
    
    var delegate: TickerDetailsDataRepositoryDelegate? { get set }
    
    var model: TickerDetailsModel { get }
    
    var tickerIdentifier: String { get }
}

protocol TickerDetailsDataRepositoryDelegate: AnyObject {
    
    func didFetchNewModel(isTickerStillSupported: Bool)
    
}
