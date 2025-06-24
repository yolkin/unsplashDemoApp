//
//  MainTabBarController.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        homeVC.title = "Photos"
        let homeNavigationController = UINavigationController(rootViewController: homeVC)
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "Photos",
            image: UIImage(systemName: "photo.stack"),
            tag: 0
        )
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.title = "Favorites"
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesVC)
        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart.fill"),
            tag: 1
        )
        
        setViewControllers([homeNavigationController, favoritesNavigationController], animated: false)
    }

}
