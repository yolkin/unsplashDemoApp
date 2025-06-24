//
//  Photo.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import Foundation

struct Photo: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let likes: Int
    let likedByUser: Bool
    let urls: PhotoURLs
    let user: User
    
    struct PhotoURLs: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    
    struct User: Codable {
        let username: String
        let name: String
    }
}
