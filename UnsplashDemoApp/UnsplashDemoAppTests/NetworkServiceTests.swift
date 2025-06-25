//
//  NetworkServiceTests.swift
//  UnsplashDemoAppTests
//
//  Created by Alexander on 24.06.25.
//

import XCTest
@testable import UnsplashDemoApp

final class NetworkServiceTests: XCTestCase {

    func testFetchPhotosSuccess() {
        let mockSession = MockURLSession()
        mockSession.mockData = mockJSON
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.unsplash.com/photos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let service = NetworkService(session: mockSession)
        
        let expectation = expectation(description: "Fetch photos")
        
        service.fetchPhotos(page: 1, perPage: 1) { result in
            switch result {
            case .success(let photos):
                XCTAssertEqual(photos.count, 1)
                XCTAssertEqual(photos.first?.id, "abc123")
            case .failure(let error):
                XCTFail("Expected success but got \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchPhotosNetworkError() {
        let mockSession = MockURLSession()
        mockSession.mockError = NSError(domain: "Network", code: -1009, userInfo: nil)
        
        let service = NetworkService(session: mockSession)
        let expectation = expectation(description: "Fetch photos network error")
        
        service.fetchPhotos(page: 1, perPage: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchPhotosDecodingFailure() {
        let mockSession = MockURLSession()
        mockSession.mockData = "invalid json".data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.unsplash.com/photos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let service = NetworkService(session: mockSession)
        let expectation = expectation(description: "Fetch photos decoding failure")
        
        service.fetchPhotos(page: 1, perPage: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, NetworkError.decodingFailed)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSearchPhotosSuccess() {
        let mockSession = MockURLSession()
        mockSession.mockData = searchMockJSON
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.unsplash.com/search/photos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let service = NetworkService(session: mockSession)
        let expectation = expectation(description: "Search photos success")
        
        service.searchPhotos(query: "blue", page: 1, perPage: 1) { result in
            switch result {
            case .success(let photos):
                XCTAssertEqual(photos.count, 1)
                XCTAssertEqual(photos.first?.description, "A beautiful blue sky")
            case .failure(let error):
                XCTFail("Expected success but got \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

}
