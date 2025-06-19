//
//  AlbumViewModelTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
import Combine
@testable import MusicPlayer

final class AlbumViewModelTests: XCTestCase {

    private var sut: AlbumViewModel!
    private var mockService: MockAlbumService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockAlbumService()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_init_shouldStartFetching() {

        // Given
        let expectation = XCTestExpectation(description: "Initial fetch")
        let expectedSongs = [AlbumSong.mock]
        let expectedAlbum = AlbumSong.mockAlbum
        mockService.mockResponse = AlbumResponse(results: [expectedAlbum] + expectedSongs)
        
        // When
        sut = AlbumViewModel(collectionId: 123, service: mockService)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut.songs.count, expectedSongs.count)
            XCTAssertEqual(self.sut.albumName, expectedAlbum.collectionName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchAlbumSongs_whenError_shouldUpdateError() {

        // Given
        let expectation = XCTestExpectation(description: "Fetch error")
        let expectedError = NSError(domain: "test", code: 0)
        mockService.mockError = expectedError
        
        // When
        sut = AlbumViewModel(collectionId: 123, service: mockService)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.sut.error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchAlbumSongs_whenLoading_shouldUpdateLoadingState() {

        // Given
        let expectation = XCTestExpectation(description: "Loading state")
        let expectedSongs = [AlbumSong.mock]
        let expectedAlbum = AlbumSong.mockAlbum
        mockService.mockResponse = AlbumResponse(results: [expectedAlbum] + expectedSongs)
        
        // When
        sut = AlbumViewModel(collectionId: 123, service: mockService)
        
        // Then
        // First check that loading is true
        XCTAssertTrue(sut.isLoading)
        
        // Then wait for loading to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.sut.isLoading)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

// MARK: - Mock Service
private class MockAlbumService: AlbumServiceProtocol {

    var mockResponse: AlbumResponse?
    var mockError: Error?
    
    func fetchAlbumSongs(collectionId: Int) -> AnyPublisher<AlbumResponse, Error> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let response = mockResponse {
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: NSError(domain: "test", code: 0)).eraseToAnyPublisher()
    }
}

// MARK: - Mock Data
extension AlbumSong {
    static let mock = AlbumSong(
        wrapperType: "track",
        collectionName: "Test Album",
        trackName: "Test Song",
        artistName: "Test Artist",
        trackId: 180000
    )
    
    static let mockAlbum = AlbumSong(
        wrapperType: "collection",
        collectionName: "Test Album",
        trackName: nil,
        artistName: "Test Artist",
        trackId: nil
    )
} 
