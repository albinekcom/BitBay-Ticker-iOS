import UIKit

final class SceneDelegate: UIResponder {

    var window: UIWindow?
    
    private let sceneCoordinator: SceneCoordinator
    
    // MARK: - Initializers
    
    init(sceneCoordinator: SceneCoordinator) {
        self.sceneCoordinator = sceneCoordinator
        
        super.init()
    }
    
    private override convenience init() {
        self.init(sceneCoordinator: MainCoordinator())
    }
    
}

extension SceneDelegate: UIWindowSceneDelegate {
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = sceneCoordinator.navigationController
        window?.makeKeyAndVisible()
        
        sceneCoordinator.start()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        sceneCoordinator.sceneDidBecomeActive()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        sceneCoordinator.sceneWillResignActive()
    }
    
}
