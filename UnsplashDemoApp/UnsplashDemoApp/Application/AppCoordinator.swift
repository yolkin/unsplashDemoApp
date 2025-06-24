//
//  AppCoordinator.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import Foundation
import UIKit

final class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = MainTabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
