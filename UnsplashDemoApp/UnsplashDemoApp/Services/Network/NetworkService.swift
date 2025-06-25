//
//  NetworkService.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import Foundation

final class NetworkService {
    private let session: URLSessionProtocol
    private let baseURL = "https://api.unsplash.com"
    private let accessKey = Bundle.unsplashAccessKey
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    @discardableResult
    func fetchPhotos(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) -> URLSessionDataTaskProtocol? {
        let endpoint = Endpoint.photos(page: page, perPage: perPage)
        return request(endpoint: endpoint, completion: completion)
    }
    
    @discardableResult
    func searchPhotos(
        query: String,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) -> URLSessionDataTaskProtocol? {
        let endpoint = Endpoint.search(query: query, page: page, perPage: perPage)
        return request(endpoint: endpoint) { (result: Result<SearchPhotosResult, Error>) in
            switch result {
            case .success(let searchResult):
                completion(.success(searchResult.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    private func request<T: Decodable>(
        endpoint: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTaskProtocol? {
        guard let request = buildRequest(for: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return nil
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            self.handleResponse(
                data: data,
                response: response,
                error: error,
                completion: completion
            )
        }
        task.resume()
        
        return task
    }
    
    private func buildRequest(for endpoint: Endpoint) -> URLRequest? {
        var components = URLComponents(string: baseURL)
        components?.path = endpoint.path
        components?.queryItems = endpoint.queryItems
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func handleResponse<T: Decodable>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(T.self, from: data)
            completion(.success(decoded))
        } catch {
            completion(.failure(NetworkError.decodingFailed))
        }
    }
}
