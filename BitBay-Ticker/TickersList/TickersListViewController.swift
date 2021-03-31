import UIKit

final class TickersListViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    weak var analyticsService: (TickersListAnalyticsService & RatingViewAnalyticsService)?
    
    private let viewModel: TickersListViewModel
    private let tickersListView: TickersListView
    
    // MARK: - Initializers

    init(tickersAndCurrenciesDataRepository: (TickersDataRepositoryProtocol & CurrenciesDataRepositoryProtocol & AutomaticTickersRefreshingProtocol)) {
        let dataRepository = TickersListDataRepository(tickersAndCurrenciesDataRepository: tickersAndCurrenciesDataRepository)
        viewModel = TickersListViewModel(dataRepository: dataRepository)
        tickersListView = TickersListView(viewModel: viewModel)
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.delegate = self
        title = viewModel.title.localized
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Managing View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareMainView(swiftUIView: tickersListView)
        preparePlusButton()
        
        displayReviewPopUpIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.resfreshModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        analyticsService?.trackDisplayedTickersListView()
    }
    
    private func preparePlusButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                           target: self,
                                                           action: #selector(showTickersAdder))
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func displayReviewPopUpIfNeeded() { // NOTE: Uncomment it before shipping
//        guard let windowScene = navigationController?.view.window?.windowScene else { return }
        
//        let reviewPopUpController = ReviewPopUpController(analyticsService: analyticsService)
//        reviewPopUpController.displayReviewPopUpIfNeeded(in: windowScene)
    }
    
    @objc private func showTickersAdder() {
        coordinator?.showTickersAdder(tickersAdderDelegate: self)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        viewModel.isEditing = isEditing
        
        if viewModel.isEditing {
            analyticsService?.trackDisplayedTickersListViewInEditMode()
        }
    }
    
}

extension TickersListViewController: TickersAdderDelegate {
    
    func tickersAdderDidAppear() {
        viewModel.tickersAdderVisible = true
    }
    
    func tickersAdderDidDismiss() {
        analyticsService?.trackDisplayedTickersListView()
        
        viewModel.tickersAdderVisible = false
    }
    
    func tickersAdderDidChangeTickers() {
        viewModel.resfreshModel()
    }
    
}

extension TickersListViewController: TickersListViewModelDelegate {
    
    func didSelectTicker(tickerIdentifier: String) {
        coordinator?.showTickerDetails(tickerIdentifier: tickerIdentifier)
    }
    
    func didRemoveTicker(tickerIdentifier: String) {
        analyticsService?.trackRemovedTicker(tickerIdentifier: tickerIdentifier)
    }
    
}
