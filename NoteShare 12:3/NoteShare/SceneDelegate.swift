import UIKit
import SwiftUI
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        // Check if user is already logged in
        if Auth.auth().currentUser != nil && UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            // User is logged in, go directly to the tab bar
            gototab()
        } else {
            // User is not logged in, start with the landing screen
            let landingVC = LandingViewController()
            let navigationController = UINavigationController(rootViewController: landingVC)
            window?.rootViewController = navigationController
        }
        
        window?.makeKeyAndVisible()
    }
    // In SceneDelegate.swift
    func showLoginScreen() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
//        gototab()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    func gototab() {
        let MyNotesViewController = SavedViewController()
        MyNotesViewController.tabBarItem = UITabBarItem(
            title: "My Notes",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        
        // Wrap AdvancedChatView in UIHostingController
        let aiViewController = UIHostingController(rootView: AdvancedChatView())
        aiViewController.tabBarItem = UITabBarItem(
            title: "AI",
            image: UIImage(systemName: "apple.intelligence"),
            selectedImage: UIImage(systemName: "apple.intelligence.fill")
        )
        
        let SearchViewController = PDFListViewController()
        SearchViewController.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        let HomeViewController = HomeViewController()
        HomeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: HomeViewController),
            UINavigationController(rootViewController: MyNotesViewController),
            UINavigationController(rootViewController: SearchViewController),
            UINavigationController(rootViewController: aiViewController)
        ]
        
        // Rest of the method remains the same...
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
        } else {
            tabBar.barTintColor = .systemGray6
            tabBar.isTranslucent = false
        }
        
        window?.rootViewController = tabBarController
    }
}

/// OLD
//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//        window?.windowScene = windowScene
//
//        // Start with the login screen
//        let landingVC = LandingViewController()
//        let navigationController = UINavigationController(rootViewController: landingVC)
//        window?.rootViewController = navigationController
//
//        window?.makeKeyAndVisible()
//    }
//
//
//
//    func sceneDidDisconnect(_ scene: UIScene) {}
//    func sceneDidBecomeActive(_ scene: UIScene) {}
//    func sceneWillResignActive(_ scene: UIScene) {}
//    func sceneWillEnterForeground(_ scene: UIScene) {}
//    func sceneDidEnterBackground(_ scene: UIScene) {}
//
//    func gototab() {
//        let MyNotesViewController = SavedViewController()
//        MyNotesViewController.tabBarItem = UITabBarItem(
//            title: "My Notes",
//            image: UIImage(systemName: "book"),
//            selectedImage: UIImage(systemName: "book.fill")
//        )
//
//        // Wrap AdvancedChatView in UIHostingController
//        let aiViewController = UIHostingController(rootView: AdvancedChatView())
//        aiViewController.tabBarItem = UITabBarItem(
//            title: "AI",
//            image: UIImage(systemName: "apple.intelligence"),
//            selectedImage: UIImage(systemName: "apple.intelligence.fill")
//        )
//
//
//        let SearchViewController = PDFListViewController()
//        SearchViewController.tabBarItem = UITabBarItem(
//            title: "Search",
//            image: UIImage(systemName: "magnifyingglass"),
//            selectedImage: UIImage(systemName: "magnifyingglass")
//        )
//
//        let HomeViewController = HomeViewController()
//        HomeViewController.tabBarItem = UITabBarItem(
//            title: "Home",
//            image: UIImage(systemName: "house"),
//            selectedImage: UIImage(systemName: "house.fill")
//        )
//
//        let tabBarController = UITabBarController()
//        tabBarController.viewControllers = [
//            UINavigationController(rootViewController: HomeViewController),
//            UINavigationController(rootViewController: MyNotesViewController),
//            UINavigationController(rootViewController: SearchViewController),
//            UINavigationController(rootViewController: aiViewController)
//        ]
//
//        // Rest of the method remains the same...
//        let tabBar = tabBarController.tabBar
//        tabBar.tintColor = .systemBlue
//        tabBar.unselectedItemTintColor = .gray
//
//        if #available(iOS 15.0, *) {
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .systemGray6
//
//            let normalItemAppearance = UITabBarItemAppearance()
//            normalItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
//            normalItemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
//            appearance.stackedLayoutAppearance = normalItemAppearance
//
//            tabBar.standardAppearance = appearance
//            tabBar.scrollEdgeAppearance = appearance
//        } else {
//            tabBar.barTintColor = .systemGray6
//            tabBar.isTranslucent = false
//        }
//
//        window?.rootViewController = tabBarController
//    }
//}
