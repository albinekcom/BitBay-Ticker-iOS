import UIKit

final class TickersAdderViewController: UIViewController, TickersAdderProtocol {
    
    weak var coordinator: MainCoordinator?
    weak var analyticsService: TickersAdderAnalyticsService?
    
    weak var delegate: TickersAdderDelegate?
    
    private let viewModel: TickersAdderViewModel
    private let tickersAdderView: TickersAdderView
    
    // MARK: - Initializers
    
    init(externalDataRepository: (TickersDataRepositoryProtocol & CurrenciesDataRepositoryProtocol & SupportedTickersDataRepositoryProtocol & TickersAppendableDataRepositoryProtocol)) {
        let dataRepository = TickersAdderDataRepository(externalDataRepository: externalDataRepository)
        
        viewModel = TickersAdderViewModel(dataRepository: dataRepository)
        tickersAdderView = TickersAdderView(viewModel: viewModel)

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
        
        prepareMainView(swiftUIView: tickersAdderView)
        prepareDoneButton()
        
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        analyticsService?.trackDisplayedTickersAdderView()
        
        delegate?.tickersAdderDidAppear()
    }
    
    private func prepareDoneButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(dismissViewController))
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.tickersAdderDidDismiss()
        }
    }
    
}

extension TickersAdderViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.tickersAdderDidDismiss()
    }
    
}

extension TickersAdderViewController: TickersAdderViewModelDelegate {
    
    func didAddTicker(tickerIdentifier: String) {
        analyticsService?.trackAddedTicker(tickerIdentifier: tickerIdentifier)
    }
    
    func didChangeTickers() {
        delegate?.tickersAdderDidChangeTickers()
    }
    
}

//

protocol TickersAdderProtocol: AnyObject {
    
    var delegate: TickersAdderDelegate? { get }
}

protocol TickersAdderDelegate: AnyObject {
    
    func tickersAdderDidAppear()
    func tickersAdderDidDismiss()
    func tickersAdderDidChangeTickers()
}

