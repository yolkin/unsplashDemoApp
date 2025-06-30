//
//  PhotoDetailsViewModel.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 30.06.25.
//

import Foundation

protocol PhotoDetailsViewModelProtocol {
    var photo: Photo { get }
    var imageURL: URL? { get }
    var description: String { get }
    var createdAt: String { get }
    var author: String { get }
    var likes: String { get }
    var isLikedPublisher: Published<Bool>.Publisher { get }
    
    func toggleLike()
    func checkInitialLikeState()
}

final class PhotoDetailsViewModel: PhotoDetailsViewModelProtocol {
    private let storageService: StorageServiceProtocol
    private(set) var photo: Photo
    
    @Published private(set) var isLiked = false
    var isLikedPublisher: Published<Bool>.Publisher { $isLiked }
    
    init(photo: Photo, storageService: StorageServiceProtocol = StorageService()) {
        self.photo = photo
        self.storageService = storageService
        checkInitialLikeState()
    }
    
    var imageURL: URL? {
        URL(string: photo.urls.regular)
    }
    
    var description: String {
        photo.description ?? "No description"
    }
    
    var createdAt: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        if let date = ISO8601DateFormatter().date(from: photo.createdAt ?? "") {
            return "Created: \(formatter.string(from: date))"
        } else {
            return "Created: Unknown"
        }
    }
    
    var author: String {
        "Author: \(photo.user.username)"
    }
    
    var likes: String {
        "Likes: \(photo.likes)"
    }
    
    func toggleLike() {
        isLiked.toggle()
        
        if isLiked {
            storageService.saveLikedPhoto(photo)
        } else {
            storageService.removeLikedPhoto(id: photo.id)
        }
        
        syncIsLikedState()
    }
    
    func checkInitialLikeState() {
        isLiked = storageService.isPhotoLiked(id: photo.id)
        
        if photo.likedByUser != isLiked {
            syncIsLikedState()
        }
    }
    
}

extension PhotoDetailsViewModel {
    fileprivate func syncIsLikedState() {
        var updatedPhoto = photo
        updatedPhoto.likedByUser = isLiked
        photo = updatedPhoto
    }
}
