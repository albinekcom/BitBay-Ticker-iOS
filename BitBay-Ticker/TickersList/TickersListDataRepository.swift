import Foundation

final class TickersListDataRepository: TickersListDataRepositoryProtocol {
    
    var isResumeAutomaticRefreshingTickersPossible: Bool = true {
        didSet {
            tickersAndCurrenciesDataRepository.isResumeAutomaticRefreshingTickersPossible = isResumeAutomaticRefreshingTickersPossible
        }
    }
    
    weak var delegate: TickersListDataRepositoryDelegate?
    
    private(set) var model = TickersListModel(tickers: [])
    
    private(set) var fetchingError: Error? = nil
    
    private let tickersAndCurrenciesDataRepository: (TickersDataRepositoryProtocol & AutomaticTickersRefreshingProtocol & CurrenciesDataRepositoryProtocol)
    
    init(tickersAndCurrenciesDataRepository: (TickersDataRepositoryProtocol & AutomaticTickersRefreshingProtocol & CurrenciesDataRepositoryProtocol)) {
        self.tickersAndCurrenciesDataRepository = tickersAndCurrenciesDataRepository
        
        tickersAndCurrenciesDataRepository.tickersDataDelegate = self
        tickersAndCurrenciesDataRepository.currenciesDataDelegate = self
    }
    
    func removeTicker(at index: Int) {
        tickersAndCurrenciesDataRepository.tickers.remove(at: index)
        
        resfreshModel()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        tickersAndCurrenciesDataRepository.tickers.move(fromOffsets: source, toOffset: destination)
        
        resfreshModel()
    }
    
    func resfreshModel() {
        let tickersOnListData: [TickerOnListData] = tickersAndCurrenciesDataRepository.tickers.map { ticker in
            let secondCurrency = Array(tickersAndCurrenciesDataRepository.currencies).filter { currency in
                currency.code == ticker.secondCurrencyCode }.first
            
            return TickerOnListData(tickerIdentifier: ticker.identifier,
                             firstCurrencyCode: ticker.firstCurrencyCode ?? "-",
                             secondCurrencyCode: ticker.secondCurrencyCode ?? "-",
                             secondCurrencyScale: secondCurrency?.scale,
                             rate: ticker.rate)
        }
        
        model = TickersListModel(tickers: tickersOnListData)
        
        delegate?.didFetchNewModel(error: fetchingError)
    }
    
    func resumeAutomaticRefreshingTickers() {
        tickersAndCurrenciesDataRepository.resumeAutomaticRefreshingTickers()
    }
    
    func pauseAutomaticRefreshingTickers() {
        tickersAndCurrenciesDataRepository.pauseAutomaticRefreshingTickers()
    }
    
}

extension TickersListDataRepository: TickersDataRepositoryDelegate {
    
    func didUpdateTickers(error: Error?) {
        fetchingError = error
        
        resfreshModel()
    }
    
}

extension TickersListDataRepository: CurrenciesDataRepositoryDelegate {
    
    func didUpdateCurrencies() {
        resfreshModel()
    }
    
}

//

protocol TickersListDataRepositoryProtocol: AutomaticTickersRefreshingProtocol {
    
    var delegate: TickersListDataRepositoryDelegate? { get set }
    
    var model: TickersListModel { get }
    
    func removeTicker(at index: Int)
    func move(from source: IndexSet, to destination: Int)
    
    func resfreshModel()
}

protocol TickersListDataRepositoryDelegate: AnyObject {
    
    func didFetchNewModel(error: Error?)
    
}

//

protocol TickersAppendableDataRepositoryProtocol: AnyObject {
    
    func appendNewTicker(with identifier: String)
    
}

protocol TickersDataRepositoryProtocol: AnyObject {
    
    var tickersDataDelegate: TickersDataRepositoryDelegate? { get set }
    
    var tickers: [Ticker] { get set }
}

protocol TickersDataRepositoryDelegate: AnyObject {
    
    func didUpdateTickers(error: Error?)
    
}

//

protocol CurrenciesDataRepositoryProtocol: AnyObject {
    
    var currenciesDataDelegate: CurrenciesDataRepositoryDelegate? { get set }
    
    var currencies: Set<Currency> { get }
}

protocol CurrenciesDataRepositoryDelegate: AnyObject {
    
    func didUpdateCurrencies()
    
}

//

protocol SupportedTickersDataRepositoryProtocol: AnyObject {
    
    var supportedTickersDataDelegate: SupportedTickersDataRepositoryDelegate? { get set }
    
    var supportedTickers: [SupportedTicker] { get }
}

protocol SupportedTickersDataRepositoryDelegate: AnyObject {
    
    func didUpdateSupportedTickers()
    
}

//

protocol AutomaticTickersRefreshingProtocol: AnyObject {
    
    var isResumeAutomaticRefreshingTickersPossible: Bool { get set }
    
    func resumeAutomaticRefreshingTickers()
    func pauseAutomaticRefreshingTickers()
}
