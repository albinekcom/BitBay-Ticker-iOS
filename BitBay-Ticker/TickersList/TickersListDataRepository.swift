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
    
    private let tickersAndCurrenciesDataRepository: (TickersDataRepositoryProtocol & AutomaticTickersRefreshingProtocol & CurrenciesDataRepositoryProtocol & MainDataRepositoryProtocol)
    
    init(tickersAndCurrenciesDataRepository: (TickersDataRepositoryProtocol & AutomaticTickersRefreshingProtocol & CurrenciesDataRepositoryProtocol & MainDataRepositoryProtocol)) {
        self.tickersAndCurrenciesDataRepository = tickersAndCurrenciesDataRepository
        
        connectDelegates()
    }
    
    func connectDelegates() {
        tickersAndCurrenciesDataRepository.tickersDataDelegate = self
        tickersAndCurrenciesDataRepository.currenciesDataDelegate = self
        tickersAndCurrenciesDataRepository.mainDataRepositoryDelegate = self
    }
    
    func removeTicker(at index: Int) {
        tickersAndCurrenciesDataRepository.userTickers.remove(at: index)
        
        resfreshModel()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        tickersAndCurrenciesDataRepository.userTickers.move(fromOffsets: source, toOffset: destination)
        
        resfreshModel()
    }
    
    func resfreshModel() {
        let tickersOnListData: [TickerOnListData] = tickersAndCurrenciesDataRepository.userTickers.map { ticker in
            let secondCurrency = tickersAndCurrenciesDataRepository.currencies[ticker.secondCurrencyCode ?? ""]
            
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

extension TickersListDataRepository: MainDataRepositoryDelegate {
    
    func didLoadLocalData() {
        delegate?.didLoadInitialModel()
    }
    
}

//

protocol TickersListDataRepositoryProtocol: AutomaticTickersRefreshingProtocol {
    
    var delegate: TickersListDataRepositoryDelegate? { get set }
    
    var model: TickersListModel { get }
    
    func removeTicker(at index: Int)
    func move(from source: IndexSet, to destination: Int)
    
    func resfreshModel()
    
    func connectDelegates()
}

protocol TickersListDataRepositoryDelegate: AnyObject {
    
    func didFetchNewModel(error: Error?)
    func didLoadInitialModel()
    
}

//

protocol TickersAppendableDataRepositoryProtocol: AnyObject {
    
    func appendNewTicker(with identifier: String)
    
}

protocol TickersDataRepositoryProtocol: AnyObject {
    
    var tickersDataDelegate: TickersDataRepositoryDelegate? { get set }
    
    var userTickers: [Ticker] { get set }
}

protocol TickersDataRepositoryDelegate: AnyObject {
    
    func didUpdateTickers(error: Error?)
    
}

//

protocol CurrenciesDataRepositoryProtocol: AnyObject {
    
    var currenciesDataDelegate: CurrenciesDataRepositoryDelegate? { get set }
    
    var currencies: [String: Currency] { get }
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

//

protocol MainDataRepositoryProtocol: AnyObject {
    
    var mainDataRepositoryDelegate: MainDataRepositoryDelegate? { get set }
}

//

protocol MainDataRepositoryDelegate: AnyObject {
    
    func didLoadLocalData()
}

