//
//  FavoritesViewModel.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 30.06.25.
//

import Foundation
import Combine

final class FavoritesViewModel: PhotosGridViewModelProtocol {
    private let storageService: StorageServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - PhotosGridViewModelProtocol
    
    var currentPage: Int = 1
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var isLoading = false
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var currentQuery: String? = nil
    var onPhotosUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    func fetchPhotos() {
        isLoading = true
        refreshPhotos()
    }
    
    func searchPhotos(query: String) {
        onError?(NetworkError.searchNotAvailable)
    }
    
    func clearPhotos() {
        photos.removeAll()
        onPhotosUpdated?()
    }
    
    func photo(at index: Int) -> Photo {
        photos[index]
    }
    
    // MARK: - Private Methods
    
    private func refreshPhotos() {
        photos = storageService.getLikedPhotos()
        isLoading = false
        onPhotosUpdated?()
    }
    
    private func setupBindings() {
        storageService.likedPhotosChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshPhotos()
            }
            .store(in: &cancellables)
    }
}
