//
//  PhotoGridViewController.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import UIKit
import Combine

class PhotoGridViewController: UIViewController {
    private var viewModel: PhotosGridViewModelProtocol
    private let photoGridView = PhotosGridView()
    
    private weak var navigator: PhotoDetailsNavigating?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchDebounceTimer: Timer?
    private let debounceInterval: TimeInterval = 0.5
    
    // MARK: - Lifecycle methods
    
    init(viewModel: PhotosGridViewModelProtocol, navigator: PhotoDetailsNavigating) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = photoGridView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupSearchController()
        setupPullToRefresh()
        setupBindings()
        setupCollectionView()
        photoGridView.showActivityIndicator(true)
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
        photoGridView.setRefreshControl(refreshControl)
    }
    
    private func setupCollectionView() {
        photoGridView.collectionViewPrefetchDataSource = self
        photoGridView.collectionViewDelegate = self
    }
    
    private func setupBindings() {
        viewModel.onPhotosUpdated = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.photoGridView.update(
                    with: self.viewModel.photos,
                    isLoadingMore: self.viewModel.currentPage > 1 && self.viewModel.isLoading
                )
                self.photoGridView.endRefreshing()
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
                self?.photoGridView.showActivityIndicator(isLoading)
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

extension PhotoGridViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard searchController.searchBar.text?.isEmpty != false else { return }
        
        let maxIndex = indexPaths.map { $0.item }.max() ?? 0
        let threshold = viewModel.photos.count - 10
        if maxIndex >= threshold && !viewModel.isLoading {
            viewModel.fetchPhotos()
        }
    }
}

extension PhotoGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photo(at: indexPath.item)
        navigator?.showPhotoDetails(for: photo)
    }
}

extension PhotoGridViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        performSearch(with: query)
    }
}

extension PhotoGridViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        performSearch(with: "")
    }
}
