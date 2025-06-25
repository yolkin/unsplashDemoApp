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
    
    // MARK: - Lifecycle methods
    
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
        homeView.collectionViewPrefetchDataSource = self
        homeView.showActivityIndicator(true)
        viewModel.fetchPhotos()
    }
    
    // MARK: - Setup Views
    
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

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let maxIndex = indexPaths.map { $0.item }.max() ?? 0
        if maxIndex >= viewModel.photos.count - 5 {
            viewModel.fetchPhotos()
        }
    }
    
}
