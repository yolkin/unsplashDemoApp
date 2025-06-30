//
//  StorageServiceTests.swift
//  UnsplashDemoAppTests
//
//  Created by Alexander on 30.06.25.
//

import XCTest
@testable import UnsplashDemoApp

final class StorageServiceTests: XCTestCase {

    var storageService: StorageServiceProtocol!
    let photo = Photo.mock
    
    override func setUp() {
        super.setUp()
        storageService = StorageService()
        UserDefaults.standard.removeObject(forKey: "likedPhotosKey")
    }
    
    func testSaveAndRetrievePhoto() {
        storageService.saveLikedPhoto(photo)
        let savedPhotos = storageService.getLikedPhotos()
        
        XCTAssertEqual(savedPhotos.count, 1)
        XCTAssertEqual(savedPhotos.first?.id, "test123")
    }
    
    func testRemovePhoto() {
        storageService.saveLikedPhoto(photo)
        storageService.removeLikedPhoto(id: "test123")
        
        XCTAssertFalse(storageService.isPhotoLiked(id: "test123"))
    }
    
    func testIsPhotoLiked() {
        storageService.saveLikedPhoto(photo)
        
        XCTAssertTrue(storageService.isPhotoLiked(id: "test123"))
        XCTAssertFalse(storageService.isPhotoLiked(id: "nonexistent"))
    }
    
    func testNoDuplicatePhotos() {
        storageService.saveLikedPhoto(photo)
        storageService.saveLikedPhoto(photo)
        
        XCTAssertEqual(storageService.getLikedPhotos().count, 1)
    }

}
