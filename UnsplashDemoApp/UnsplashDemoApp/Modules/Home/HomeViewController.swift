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
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchDebounceTimer: Timer?
    private let debounceInterval: TimeInterval = 0.5
    
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
        setupSearchController()
        setupPullToRefresh()
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
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search photos"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefreshHandler), for: .valueChanged)
        homeView.setRefreshControl(refreshControl)
    }
    
    private func setupBindings() {
        viewModel.onPhotosUpdated = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.homeView.update(
                    with: self.viewModel.photos,
                    isLoadingMore: self.viewModel.currentPage > 1 && self.viewModel.isLoading
                )
                self.homeView.endRefreshing()
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
    
    // MARK: - Search Logic
    
    private func performSearch(with query: String) {
        searchDebounceTimer?.invalidate()
        
        searchDebounceTimer = Timer.scheduledTimer(
            withTimeInterval: debounceInterval,
            repeats: false
        ) { [weak self] _ in
            guard let self else { return }
            
            if query.isEmpty {
                viewModel.clearPhotos()
                viewModel.fetchPhotos()
            } else {
                viewModel.searchPhotos(query: query)
            }
        }
    }
    
    // MARK: - Pull to Refresh
    
    @objc private func pullToRefreshHandler() {
        viewModel.clearPhotos()
        if let query = viewModel.currentQuery, !query.isEmpty {
            viewModel.searchPhotos(query: query)
            searchController.searchBar.endEditing(true)
        } else {
            viewModel.fetchPhotos()
        }
    }

}

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard searchController.searchBar.text?.isEmpty != false else { return }
        
        let maxIndex = indexPaths.map { $0.item }.max() ?? 0
        let threshold = viewModel.photos.count - 10
        if maxIndex >= threshold && !viewModel.isLoading {
            viewModel.fetchPhotos()
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        performSearch(with: query)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        performSearch(with: "")
    }
}
