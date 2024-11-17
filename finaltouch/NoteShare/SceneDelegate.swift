import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
    
        let exploreViewController = ExploreViewController()
        exploreViewController.tabBarItem = UITabBarItem(
            title: "Explore",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.fill")
        )
        
        let MyNotesViewController = FavouriteViewController()
        MyNotesViewController.tabBarItem = UITabBarItem(
            title: "My Notes",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        let AiViewController = AIAssistantViewController()
        AiViewController.tabBarItem = UITabBarItem(
            title: "AI",
            image: UIImage(systemName: "sparkles"),
            selectedImage: UIImage(systemName: "sparkles.fill")
        )
        
        let HomeViewController = HomeViewController()
        HomeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        
        
        
        // Initialize the tab bar controller and add the view controllers
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: HomeViewController),
            UINavigationController(rootViewController: MyNotesViewController),
            UINavigationController(rootViewController: exploreViewController),
            UINavigationController(rootViewController: AiViewController)
            
            
        ]

        
        let tabBar = tabBarController.tabBar
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGray6
            
            let normalItemAppearance = UITabBarItemAppearance()
            normalItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            normalItemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
            appearance.stackedLayoutAppearance = normalItemAppearance
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        else {
            tabBar.barTintColor = .systemGray6
            tabBar.isTranslucent = false
        }

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
    }
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
