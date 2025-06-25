//
//  SearchPhotosResult.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 25.06.25.
//

import Foundation

struct SearchPhotosResult: Codable {
    var results: [Photo]
    let total: Int
    let totalPages: Int
}
