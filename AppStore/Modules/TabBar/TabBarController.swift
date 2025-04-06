//
//  TabBarController.swift
//  AppStore
//
//  Created by Dmitry Volkov on 26/03/2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [createNavController(viewController: AppsViewController(), title: "Apps", imageName: "square.stack.3d.up.fill"),
                           createNavController(viewController: AppSearchController(), title: "Search", imageName: "magnifyingglass"),
                           createNavController(viewController: HomeViewController(), title: "Profile", imageName: "person.fill")]
    }
    
    
    
    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        return navController
    }
}
