import SwiftUI

final class SceneDelegate: UIResponder {
    
    var window: UIWindow?
    
}

extension SceneDelegate: UIWindowSceneDelegate {
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: TickerList())
        window?.makeKeyAndVisible()
    }
    
}
