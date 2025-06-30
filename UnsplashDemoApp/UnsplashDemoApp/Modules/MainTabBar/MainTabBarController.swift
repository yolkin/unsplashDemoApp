//
//  MainTabBarController.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private var navigator: PhotoDetailsNavigating
    
    init(navigator: PhotoDetailsNavigating) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
        setupViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewControllers() {
        let networkService = NetworkService()
        let homeViewModel = HomeViewModel(networkService: networkService)
        let homeVC = HomeViewController(viewModel: homeViewModel, navigator: navigator)
        let homeNavigationController = UINavigationController(rootViewController: homeVC)
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "Photos",
            image: UIImage(systemName: "photo.stack"),
            tag: 0
        )
        
        let favoritesVC = FavoritesViewController()
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesVC)
        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart.fill"),
            tag: 1
        )
        
        setViewControllers([homeNavigationController, favoritesNavigationController], animated: false)
    }

}
