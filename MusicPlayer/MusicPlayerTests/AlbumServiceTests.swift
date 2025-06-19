//
//  AlbumServiceTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
import Combine
@testable import MusicPlayer

final class AlbumServiceTests: XCTestCase {

    private var sut: AlbumService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = AlbumService()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchAlbumSongs_whenValidCollectionId_shouldReturnResults() {

        // Given
        let expectation = XCTestExpectation(description: "Fetch album songs")
        let collectionId = 576670451 // A valid iTunes collection ID
        
        // When
        sut.fetchAlbumSongs(collectionId: collectionId)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertFalse(response.results.isEmpty)
                XCTAssertTrue(response.results.contains { $0.wrapperType == "collection" })
                XCTAssertTrue(response.results.contains { $0.wrapperType == "track" })
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetchAlbumSongs_whenInvalidCollectionId_shouldFail() {

        // Given
        let expectation = XCTestExpectation(description: "Fetch with invalid ID")
        let invalidCollectionId = -1
        
        // When
        sut.fetchAlbumSongs(collectionId: invalidCollectionId)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                // Then
                XCTFail("Should fail")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
} 
