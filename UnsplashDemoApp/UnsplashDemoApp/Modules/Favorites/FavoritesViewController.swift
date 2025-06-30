//
//  FavoritesViewController.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import UIKit
import Combine

class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    private let photosView = PhotosGridView(mode: .favorites)
    private var cancellables = Set<AnyCancellable>()
    private weak var navigator: PhotoDetailsNavigating?
    
    init(storageService: StorageServiceProtocol, navigator: PhotoDetailsNavigating) {
        self.viewModel = FavoritesViewModel(storageService: storageService)
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = photosView
        photosView.collectionViewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchPhotos()
    }
    
    private func setupUI() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupBindings() {
        viewModel.onPhotosUpdated = { [weak self] in
            guard let self else { return }
            photosView.update(
                with: viewModel.photos,
                isLoadingMore: false
            )
        }
        
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.photosView.showActivityIndicator(isLoading)
            }
            .store(in: &cancellables)
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photo(at: indexPath.item)
        navigator?.showPhotoDetails(for: photo)
    }
}
