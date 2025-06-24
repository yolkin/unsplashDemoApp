//
//  HomeViewModelTests.swift
//  UnsplashDemoAppTests
//
//  Created by Alexander on 24.06.25.
//

import XCTest
@testable import UnsplashDemoApp

final class HomeViewModelTests: XCTestCase {

    var mockSession: MockURLSession!
    var networkService: NetworkService!
    var viewModel: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
        viewModel = HomeViewModel(networkService: networkService)
    }
    
    func testFetchPhotosSuccess() {
        mockSession.mockData = mockJSON
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.unsplash.com/photos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = expectation(description: "Photos updated called")
        
        viewModel.onPhotosUpdated = {
            expectation.fulfill()
        }
        
        viewModel.fetchPhotos()
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(viewModel.photos.count, 1)
        XCTAssertEqual(viewModel.photos.first?.id, "abc123")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFetchPhotosFailure() {
        mockSession.mockError = NSError(domain: "Network", code: -1)
        
        let expectation = expectation(description: "Error called")
        
        viewModel.onError = { error in
            expectation.fulfill()
        }
        
        viewModel.fetchPhotos()
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testSearchPhotosSuccess() {
        mockSession.mockData = mockJSON
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.unsplash.com/search/photos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = expectation(description: "Photos updated called")
        
        viewModel.onPhotosUpdated = {
            expectation.fulfill()
        }
        
        viewModel.searchPhotos(query: "blue")
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(viewModel.photos.count, 1)
        XCTAssertEqual(viewModel.photos.first?.id, "abc123")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testSearchPhotosFailure() {
        mockSession.mockError = NSError(domain: "Network", code: -1)
        
        let expectation = expectation(description: "Error called")
        
        viewModel.onError = { error in
            expectation.fulfill()
        }
        
        viewModel.searchPhotos(query: "blue")
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testSearchPhotosWhenLoadingOrEmptyQueryDoesNothing() {
        viewModel.isLoading = true
        viewModel.searchPhotos(query: "test")
        XCTAssertTrue(viewModel.photos.isEmpty)
        
        viewModel.isLoading = false
        viewModel.searchPhotos(query: "")
        XCTAssertTrue(viewModel.photos.isEmpty)
    }
    
    func testPhotoAtIndex() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        viewModel.photos = [try! decoder.decode([Photo].self, from: mockJSON).first!]
        
        let photo = viewModel.photo(at: 0)
        
        XCTAssertEqual(photo.id, "abc123")
    }

}
