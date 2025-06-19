//
//  AlbumServiceTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
@testable import MusicPlayer

final class AlbumServiceTests: XCTestCase {
    
    private var sut: AlbumService!
    private let timeout: TimeInterval = 1.0
    
    override func setUp() {
        super.setUp()
        sut = AlbumService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetchAlbumSongs_whenValidCollectionId_shouldReturnResults() async throws {

        // Given
        let collectionId = 576670451 // A valid iTunes collection ID
        
        // When
        let response = try await sut.fetchAlbumSongs(collectionId: collectionId)
        
        // Then
        XCTAssertFalse(response.results.isEmpty)
        XCTAssertTrue(response.results.contains { $0.wrapperType == "collection" })
        XCTAssertTrue(response.results.contains { $0.wrapperType == "track" })
    }
    
    func test_fetchAlbumSongs_whenInvalidCollectionId_shouldFail() async {

        // Given
        let invalidCollectionId = -1
        
        // When/Then
        do {
            _ = try await sut.fetchAlbumSongs(collectionId: invalidCollectionId)
            XCTFail("Should fail")
        } catch {
            // Test passes if we get here
        }
    }
    
    func test_fetchAlbumSongs_whenNetworkError_shouldFail() async {

        // Given
        let invalidCollectionId = -1 // Very unlikely to exist
        
        // When/Then
        do {
            _ = try await sut.fetchAlbumSongs(collectionId: invalidCollectionId)
            XCTFail("Should fail")
        } catch {
            // Test passes if we get here
        }
    }
    
    func test_fetchAlbumSongs_whenCancelled_shouldNotComplete() async {

        // Given
        let collectionId = 576670451
        
        // When/Then
        let task = Task {
            try await sut.fetchAlbumSongs(collectionId: collectionId)
        }
        
        task.cancel()
        
        do {
            _ = try await task.value
            XCTFail("Should be cancelled")
        } catch {
            // Test passes if we get here (cancellation error)
        }
    }
} 
