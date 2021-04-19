import UIKit

final class TickersListViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    weak var analyticsService: (TickersListAnalyticsService & ReviewViewAnalyticsService)? {
        didSet {
            reviewController.analyticsService = analyticsService
        }
    }
    
    private let viewModel: TickersListViewModel
    private let tickersListView: TickersListView
    private let reviewController: ReviewController
    
    // MARK: - Initializers

    init(tickersAndCurrenciesDataRepository: (TickersDataRepositoryProtocol & CurrenciesDataRepositoryProtocol & AutomaticTickersRefreshingProtocol & MainDataRepositoryProtocol),
         reviewController: ReviewController = NativeReviewController()) {
        let dataRepository = TickersListDataRepository(tickersAndCurrenciesDataRepository: tickersAndCurrenciesDataRepository)
        viewModel = TickersListViewModel(dataRepository: dataRepository)
        tickersListView = TickersListView(viewModel: viewModel)
        self.reviewController = reviewController
        
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
        
//        reviewController.requestReview(in: navigationController?.view.window?.windowScene) // NOTE: Uncomment this line before shipping the application
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.reconnectDataRepositoryDelegates()
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
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
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
        viewModel.reconnectDataRepositoryDelegates()
        
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
    
    func didChangeUsInitialModelLoaded() {
        navigationItem.leftBarButtonItem?.isEnabled = viewModel.isInitialModelLoaded
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.isInitialModelLoaded
    }
    
}
