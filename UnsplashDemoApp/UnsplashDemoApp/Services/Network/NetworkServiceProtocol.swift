//
//  NetworkServiceProtocol.swift
//  DemoApp
//
//  Created by Alexander on 24.06.25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchPhotos(page: Int, perPage: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
    func searchPhotos(query: String, page: Int, perPage: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
}
