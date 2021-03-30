import UIKit

final class TickerDetailsViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    weak var analyticsService: TickerDetailsAnalyticsService?
    
    private let viewModel: TickerDetailsViewModel
    private let tickerDetailsView: TickerDetailsView
    
    // MARK: - Initializers
    
    init(tickerIdentifier: String, tickersAndCurrenciesDataRepository: (TickersDataRepositoryProtocol & CurrenciesDataRepositoryProtocol)) {
        let dataRepository = TickerDetailsDataRepository(tickerIdentifier: tickerIdentifier,
                                                         tickersAndCurrenciesDataRepository: tickersAndCurrenciesDataRepository)
        
        viewModel = TickerDetailsViewModel(dataRepository: dataRepository)
        tickerDetailsView = TickerDetailsView(viewModel: viewModel)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Managing View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareMainView(swiftUIView: tickerDetailsView)
        
        title = viewModel.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        analyticsService?.trackDisplayedTickerDetailsView(tickerIdentifier: viewModel.tickerIdentifier)
    }
    
}
