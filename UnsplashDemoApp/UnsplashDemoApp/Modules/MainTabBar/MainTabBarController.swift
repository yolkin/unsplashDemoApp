//
//  MainTabBarController.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private var navigator: PhotoDetailsNavigating
    private let storageService: StorageServiceProtocol
    
    init(navigator: PhotoDetailsNavigating, storageService: StorageServiceProtocol) {
        self.navigator = navigator
        self.storageService = storageService
        super.init(nibName: nil, bundle: nil)
        setupViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewControllers() {
        let networkService = NetworkService()
        let photosGridViewModel = PhotosGridViewModel(networkService: networkService)
        let photosGridVC = PhotoGridViewController(
            viewModel: photosGridViewModel,
            navigator: navigator
        )
        let photosNavigationController = UINavigationController(rootViewController: photosGridVC)
        photosNavigationController.tabBarItem = UITabBarItem(
            title: "Photos",
            image: UIImage(systemName: "photo.stack"),
            tag: 0
        )
        
        let favoritesVC = FavoritesViewController(
            storageService: storageService,
            navigator: navigator
        )
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesVC)
        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart.fill"),
            tag: 1
        )
        
        setViewControllers([photosNavigationController, favoritesNavigationController], animated: false)
    }

}
