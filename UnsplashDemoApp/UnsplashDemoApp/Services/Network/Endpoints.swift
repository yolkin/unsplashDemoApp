//
//  Endpoints.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import Foundation

enum Endpoint {
    case photos(page: Int, perPage: Int)
    case search(query: String, page: Int, perPage: Int)
    
    var path: String {
        switch self {
        case .photos: 
            return "/photos"
        case .search: 
            return "/search/photos"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .photos(let page, let perPage):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ]
        case .search(let query, let page, let perPage):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ]
        }
    }
}
