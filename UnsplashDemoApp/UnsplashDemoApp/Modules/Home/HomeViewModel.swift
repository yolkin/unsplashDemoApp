//
//  HomeViewModel.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import Foundation

protocol HomeViewModelProtocol {
    var photos: [Photo] { get }
    var isLoading: Bool { get }
    var onPhotosUpdated: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func fetchPhotos()
    func searchPhotos(query: String)
    func photo(at index: Int) -> Photo
}

final class HomeViewModel: HomeViewModelProtocol {
    private let networkService: NetworkService
    private var currentPage = 1
    private let perPage = 20
    
    var photos: [Photo] = []
    var isLoading = false
    
    var onPhotosUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    var numberOfPhotos: Int {
        photos.count
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchPhotos() {
        guard !isLoading else { return }
        
        isLoading = true
        networkService.fetchPhotos(
            page: currentPage,
            perPage: perPage
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let newPhotos):
                self.currentPage += 1
                self.photos.append(contentsOf: newPhotos)
                self.onPhotosUpdated?()
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    func searchPhotos(query: String) {
        guard !isLoading, !query.isEmpty else { return }
        
        isLoading = true
        currentPage = 1
        photos.removeAll()
        
        networkService.searchPhotos(
            query: query,
            page: currentPage,
            perPage: perPage
        ) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let newPhotos):
                self.currentPage += 1
                self.photos = newPhotos
                self.onPhotosUpdated?()
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    func photo(at index: Int) -> Photo {
        photos[index]
    }
}
