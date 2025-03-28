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
        
        viewControllers = [createNavController(viewController: AppSearchController(), title: "Home", imageName: "trash.circle"),
                           createNavController(viewController: HomeViewController(), title: "Red", imageName: "pencil.tip.crop.circle"),
                           createNavController(viewController: HomeViewController(), title: "Blue", imageName: "rectangle.portrait.and.arrow.right.fill")]
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
