import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    //UIKit
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: windowScene)
//        let rootVC = MainViewController()
//        window?.rootViewController = UINavigationController(rootViewController: rootVC)
//        window?.makeKeyAndVisible()
//    }
    
    //SwiftUI
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootVC = UIHostingController(rootView: MainView())
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}

