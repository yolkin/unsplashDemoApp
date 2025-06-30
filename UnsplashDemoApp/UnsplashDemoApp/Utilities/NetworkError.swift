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
    case searchNotAvailable
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid. Please check the request."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .decodingFailed:
            return "Failed to decode the response data."
        case .searchNotAvailable:
            return "Search not available for favorites"
        }
    }
}
