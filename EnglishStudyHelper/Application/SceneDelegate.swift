import UIKit
import SwiftyDropbox

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootVC = MainViewController()
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let oauthCompletion: DropboxOAuthCompletion = {
            if let authResult = $0 {
                switch authResult {
                case .success:
                    print("Success! User is logged into DropboxClientsManager.")
                case .cancel:
                    print("Authorization flow was manually canceled by user!")
                case .error(_, let description):
                    print("Error: \(String(describing: description))")
                }
            }
        }
        
        for context in URLContexts {
            if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
        }
    }
}

