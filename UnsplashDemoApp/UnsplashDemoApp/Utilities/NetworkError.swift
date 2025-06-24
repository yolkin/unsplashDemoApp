//
//  NetworkError.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 24.06.25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}
