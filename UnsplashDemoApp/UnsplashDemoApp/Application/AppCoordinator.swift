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
    private var tabBarController: MainTabBarController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = MainTabBarController(navigator: self)
        self.tabBarController = tabBarController
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    // MARK: - Photo Details Navigating
    
    func showPhotoDetails(for photo: Photo) {
        let detailsVC = PhotoDetailsViewController(photo: photo)
        detailsVC.hidesBottomBarWhenPushed = true
        if let navController = tabBarController?.selectedViewController as? UINavigationController {
            navController.navigationBar.isTranslucent = true
            navController.pushViewController(detailsVC, animated: true)
        }
    }
}
