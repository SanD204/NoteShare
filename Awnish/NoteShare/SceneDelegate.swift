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
        
        // uplaod
        let uploadViewController = MainViewController()
        uploadViewController.tabBarItem = UITabBarItem(
            title: "upload",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.fill")
        )
        
        //home
        let HomeViewController = HomeViewController()
        HomeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.fill")
        )
        
        
        let subjectsViewController = SubjectsViewController()
        subjectsViewController.tabBarItem = UITabBarItem(
            title: "Subjects",
            image: UIImage(systemName: "book.fill"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        let coursesViewController = NotesViewController()
        coursesViewController.view.backgroundColor = .systemBackground
        coursesViewController.tabBarItem = UITabBarItem(
            title: "Noteslist",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        
        // Set up the 'Profile' tab with a basic placeholder view controller
        let profileViewController = CardViewController()
        profileViewController.view.backgroundColor = .systemBackground
        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
    
        // Initialize the tab bar controller and add the view controllers
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: exploreViewController),
            UINavigationController(rootViewController: subjectsViewController),
            UINavigationController(rootViewController: coursesViewController),
            UINavigationController(rootViewController: profileViewController),
            UINavigationController(rootViewController: uploadViewController),
//            UINavigationController(rootViewController: searchViewController),
            UINavigationController(rootViewController: HomeViewController)
        ]
        
        // Customize tab bar appearance
        let tabBar = tabBarController.tabBar
        tabBar.tintColor = .systemBlue // Selected item color
        tabBar.unselectedItemTintColor = .gray // Unselected item color
        
        // Set up tab bar appearance for iOS 15+
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGray6 // Light grey background
            
            // Customize normal item appearance
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
