//
//  MockURLSession.swift
//  DemoApp
//
//  Created by Alexander on 24.06.25.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    func resume() {
        closure()
    }
    func cancel() { }
}

final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask {
            completionHandler(self.mockData, self.mockResponse, self.mockError)
        }
    }
}
