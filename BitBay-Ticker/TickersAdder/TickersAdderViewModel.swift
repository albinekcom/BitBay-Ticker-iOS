import Foundation

protocol TickersAdderViewModelDelegate: AnyObject {
    
    func didChangeTickers()
    func didAddTicker(tickerIdentifier: String)
    
}

final class TickersAdderViewModel: ObservableObject {
    
    @Published var searchTerm: String = "" {
        didSet {
            updateOutputProperties()
        }
    }
    
    @Published private(set) var rowsData: [TickersAdderRowData] = []
    
    weak var delegate: TickersAdderViewModelDelegate?
    
    private let dataRepository: TickersAdderDataRepositoryProtocol
    
    let title = "Add Ticker"
    
    init(dataRepository: TickersAdderDataRepositoryProtocol) {
        self.dataRepository = dataRepository
        self.dataRepository.delegate = self
        
        updateOutputProperties()
    }
    
    private func updateOutputProperties() {
        let filteredTickers: [TickerOnAdderData]
        
        if searchTerm.isEmpty == false {
            filteredTickers = dataRepository.model.tickers.filter { $0.isSearchTermInTags(searchTerm: searchTerm) }
        } else {
            filteredTickers = dataRepository.model.tickers
        }
        
        rowsData = filteredTickers.map { ticker in
            TickersAdderRowData(id: ticker.tickerIdentifier,
                                iconName: ticker.firstCurrencyCode,
                                firstCurrencyCode: ticker.firstCurrencyCode,
                                secondCurrencyCode: ticker.secondCurrencyCode)
        }
    }
    
    func selectRow(row: TickersAdderRowData) {
        dataRepository.appendNewTicker(tickerIdentifier: row.id)
        delegate?.didAddTicker(tickerIdentifier: row.id)
    }
    
}

extension TickersAdderViewModel: TickersAdderDataRepositoryDelegate {
    
    func didFetchNewModel() {
        updateOutputProperties()
        delegate?.didChangeTickers()
    }
    
}
