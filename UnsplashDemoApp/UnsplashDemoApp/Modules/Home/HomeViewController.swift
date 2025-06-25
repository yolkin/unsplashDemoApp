//
//  HomeViewController.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModelProtocol
    private let homeView = HomeView()
    
    private var cancellables = Set<AnyCancellable>()
    
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
        setupNavigationController()
        setupBindings()
        homeView.showActivityIndicator(true)
        viewModel.fetchPhotos()
    }
    
    private func setupNavigationController() {
        title = "Photos"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupBindings() {
        viewModel.onPhotosUpdated = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.homeView.update(with: self.viewModel.photos)
            }
        }
        
        viewModel.onError = { [weak self] error in
            guard let self else { return }
            DispatchQueue.main.async {
                self.showErrorAlert(error)
            }
        }
        
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.homeView.showActivityIndicator(isLoading)
            }
            .store(in: &cancellables)
    }

}
