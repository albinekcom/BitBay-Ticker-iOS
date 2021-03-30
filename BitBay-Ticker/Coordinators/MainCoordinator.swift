import UIKit

final class MainCoordinator: SceneCoordinator {
    
    var childCoordinators: [Coordinator] = []
    
    let navigationController: UINavigationController
    
    private let analyticsService: AnalyticsService
    private let mainDataRepository: MainDataRepository
    
    // MARK: - Initializer

    init(mainDataRepository: MainDataRepository = MainDataRepository(),
         analyticsService: AnalyticsService = FirbaseAnalyticsService(),
         navigationController: UINavigationController = UINavigationController()) {
        self.analyticsService = analyticsService
        self.mainDataRepository = mainDataRepository
        self.mainDataRepository.analyticsService = self.analyticsService
        
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Start

    func start() {
        showTickersList()
    }
    
    // MARK: - Flows
    
    func showTickersList(isAnimated: Bool = false) {
        let tickersListViewController = TickersListViewController(tickersAndCurrenciesDataRepository: mainDataRepository)
        tickersListViewController.coordinator = self
        tickersListViewController.analyticsService = analyticsService
        
        navigationController.pushViewController(tickersListViewController, animated: isAnimated)
    }
    
    func showTickersAdder(tickersAdderDelegate: TickersAdderDelegate?) {
        let tickersAdderViewController = TickersAdderViewController(externalDataRepository: mainDataRepository)
        tickersAdderViewController.delegate = tickersAdderDelegate
        tickersAdderViewController.coordinator = self
        tickersAdderViewController.analyticsService = analyticsService
        
        let navigationControllerWithTickersAdderViewController = UINavigationController(rootViewController: tickersAdderViewController)
        
        navigationController.present(navigationControllerWithTickersAdderViewController, animated: true)
    }

    func showTickerDetails(tickerIdentifier: String) {
        let tickerDetailsViewController = TickerDetailsViewController(tickerIdentifier: tickerIdentifier,
                                                                      tickersAndCurrenciesDataRepository: mainDataRepository)
        tickerDetailsViewController.coordinator = self
        tickerDetailsViewController.analyticsService = analyticsService
        
        navigationController.pushViewController(tickerDetailsViewController, animated: true)
    }
    
    // MARK: - Behaviors
    
    func sceneDidBecomeActive() {
        mainDataRepository.resumeAutomaticRefreshingTickers()
    }
    
    func sceneWillResignActive() {
        mainDataRepository.pauseAutomaticRefreshingTickers()
        mainDataRepository.saveDataLocally()
    }
    
}
