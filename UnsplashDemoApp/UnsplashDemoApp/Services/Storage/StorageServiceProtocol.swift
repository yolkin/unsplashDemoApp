//
//  StorageServiceProtocol.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 30.06.25.
//

import Foundation

protocol StorageServiceProtocol {
    func saveLikedPhoto(_ photo: Photo)
    func removeLikedPhoto(id: String)
    func getLikedPhotos() -> [Photo]
    func isPhotoLiked(id: String) -> Bool
}
