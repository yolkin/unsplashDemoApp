//
//  FavoritesViewController.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import UIKit

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
