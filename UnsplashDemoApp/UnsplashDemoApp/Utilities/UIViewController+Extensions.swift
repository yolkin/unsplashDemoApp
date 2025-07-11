//
//  UIViewController+Extensions.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 24.06.25.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(_ error: Error) {
        let okAction = UIAlertAction(title: "OK", style: .default)
        let alert = UIAlertController(
            title: error.localizedDescription,
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}
