//
//  NetworkService.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSessionProtocol
    private let baseURL = "https://api.unsplash.com"
    private let accessKey = Bundle.unsplashAccessKey
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchPhotos(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        let endpoint = Endpoint.photos(page: page, perPage: perPage)
        request(endpoint: endpoint, completion: completion)
    }
    
    func searchPhotos(
        query: String,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        let endpoint = Endpoint.search(query: query, page: page, perPage: perPage)
        request(endpoint: endpoint, completion: completion)
    }
    
    private func request<T: Decodable>(
        endpoint: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var components = URLComponents(string: baseURL)!
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        var request = URLRequest(url: components.url!)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
