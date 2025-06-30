//
//  MockPhoto.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 30.06.25.
//

import Foundation

extension Photo {
    static var mock: Photo {
        Photo(
            id: "test123",
            width: 4000,
            height: 3000,
            createdAt: "2023-01-01T12:00:00Z",
            description: "Test description",
            likes: 42,
            likedByUser: false,
            urls: Photo.PhotoURLs(
                raw: "https://test.com/raw.jpg",
                full: "https://test.com/full.jpg",
                regular: "https://test.com/regular.jpg",
                small: "https://test.com/small.jpg",
                thumb: "https://test.com/thumb.jpg"
            ),
            user: Photo.User(
                id: "1",
                username: "testuser",
                name: "Test User"
            )
        )
    }
}
