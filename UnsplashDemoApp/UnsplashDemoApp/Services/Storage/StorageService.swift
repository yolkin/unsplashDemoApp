//
//  StorageService.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 30.06.25.
//

import Foundation
import Combine

final class StorageService: StorageServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let likedPhotosKey = "likedPhotosKey"
    
    let likedPhotosChanged = PassthroughSubject<Void, Never>()
    
    func saveLikedPhoto(_ photo: Photo) {
        var likedPhotos = getLikedPhotos()
        guard !likedPhotos.contains(where: { $0.id == photo.id }) else { return }
        
        likedPhotos.append(photo)
        save(photos: likedPhotos)
    }
    
    func removeLikedPhoto(id: String) {
        var likedPhotos = getLikedPhotos()
        likedPhotos.removeAll { $0.id == id }
        save(photos: likedPhotos)
    }
    
    func getLikedPhotos() -> [Photo] {
        guard let data = UserDefaults.standard.data(forKey: likedPhotosKey),
              let photos = try? JSONDecoder().decode([Photo].self, from: data) else {
            return []
        }
        return photos
    }
    
    func isPhotoLiked(id: String) -> Bool {
        return getLikedPhotos().contains { $0.id == id }
    }
    
    private func save(photos: [Photo]) {
        if let data = try? JSONEncoder().encode(photos) {
            UserDefaults.standard.set(data, forKey: likedPhotosKey)
            likedPhotosChanged.send()
        }
    }
}
