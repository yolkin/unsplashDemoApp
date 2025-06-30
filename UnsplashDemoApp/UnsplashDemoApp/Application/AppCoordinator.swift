//
//  AppCoordinator.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import Foundation
import UIKit

protocol PhotoDetailsNavigating: AnyObject {
    func showPhotoDetails(for photo: Photo)
}

final class AppCoordinator: PhotoDetailsNavigating {
    private let window: UIWindow
    private var launchWindow: UIWindow?
    private var tabBarController: MainTabBarController?
    private let storageService: StorageServiceProtocol
    
    init(window: UIWindow, storageService: StorageServiceProtocol = StorageService()) {
        self.window = window
        self.storageService = storageService
    }
    
    func start() {
        let splashVC = SplashViewController()
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showApp()
            self.hideLaunchScreen()
        }
    }
    
    private func showLaunchScreen() {
        let launchWindow = UIWindow(frame: UIScreen.main.bounds)
        let launchVC = SplashViewController()
        launchWindow.rootViewController = launchVC
        launchWindow.windowLevel = .normal + 1
        launchWindow.makeKeyAndVisible()
        self.launchWindow = launchWindow
    }
    
    private func hideLaunchScreen() {
        UIView.animate(withDuration: 0.3, animations: {
            self.launchWindow?.alpha = 0
        }, completion: { _ in
            self.launchWindow?.isHidden = true
            self.launchWindow = nil
        })
    }
    
    private func showApp() {
        let tabBarController = MainTabBarController(navigator: self, storageService: storageService)
        self.tabBarController = tabBarController
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    // MARK: - Photo Details Navigating
    
    func showPhotoDetails(for photo: Photo) {
        let viewModel = PhotoDetailsViewModel(
            photo: photo,
            storageService: storageService
        )
        let detailsVC = PhotoDetailsViewController(viewModel: viewModel)
        detailsVC.hidesBottomBarWhenPushed = true
        if let navController = tabBarController?.selectedViewController as? UINavigationController {
            navController.navigationBar.isTranslucent = true
            navController.pushViewController(detailsVC, animated: true)
        }
    }
}
