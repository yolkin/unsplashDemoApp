//
//  HomeViewController.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import UIKit

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModelProtocol
    private let homeView = HomeView()
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.fetchPhotos()
    }
    
    private func setupBindings() {
        viewModel.onPhotosUpdated = { [weak self] in
            DispatchQueue.main.async {
//                self?.homeView.update(with: self?.viewModel.photos ?? [])
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showErrorAlert(error)
            }
        }
    }
    

}
