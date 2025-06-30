//
//  HomeViewModel.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var currentPage: Int { get }
    var photos: [Photo] { get }
    var isLoading: Bool { get }
    var currentQuery: String? { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var onPhotosUpdated: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func fetchPhotos()
    func searchPhotos(query: String)
    func clearPhotos()
    func photo(at index: Int) -> Photo
}

final class HomeViewModel: HomeViewModelProtocol {
    private let networkService: NetworkService
    private let perPage = 20
    private var hasReachedEnd = false
    
    var currentPage = 1
    
    var photos: [Photo] = []
    
    @Published var isLoading = false
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    
    var currentQuery: String?
    
    var onPhotosUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private var currentTask: URLSessionDataTaskProtocol?
    
    var numberOfPhotos: Int {
        photos.count
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchPhotos() {
        guard !isLoading && !hasReachedEnd else { return }
        
        let isInitialLoad = photos.isEmpty || currentPage == 1
        if isInitialLoad {
            isLoading = true
        }
        
        networkService.fetchPhotos(
            page: currentPage,
            perPage: perPage
        ) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let newPhotos):
                    if newPhotos.isEmpty {
                        self.hasReachedEnd = true
                        self.onPhotosUpdated?()
                        return
                    }
                    
                    self.currentPage += 1
                    // Unsplash API sometimes includes duplicates of the last items from the previous page in the next page.
                    // We remove any photos that are already present before appending new ones.
                    let existingIDs = Set(self.photos.map { $0.id })
                    let uniqueNewPhotos = newPhotos.filter { !existingIDs.contains($0.id) }
                    self.photos.append(contentsOf: uniqueNewPhotos)
                    self.onPhotosUpdated?()
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
    
    func searchPhotos(query: String) {
        currentTask?.cancel()
        
        guard !query.isEmpty else { return }
        
        isLoading = true
        currentPage = 1
        photos.removeAll()
        currentQuery = query
        
        currentTask = networkService.searchPhotos(
            query: query,
            page: currentPage,
            perPage: perPage
        ) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.currentTask = nil
                
                switch result {
                case .success(let newPhotos):
                    self.currentPage += 1
                    self.photos = newPhotos
                    self.onPhotosUpdated?()
                case .failure(let error as NSError) where error.code == NSURLErrorCancelled:
                    break
                case .failure(let error):
                    print(error)
                    self.onError?(error)
                }
            }
        }
    }
    
    func clearPhotos() {
        photos.removeAll()
        currentPage = 1
        currentQuery = nil
    }
    
    func photo(at index: Int) -> Photo {
        photos[index]
    }
}
