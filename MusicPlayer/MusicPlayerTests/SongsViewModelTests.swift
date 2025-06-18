//
//  SongsViewModelTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
import Combine
@testable import MusicPlayer

final class SongsViewModelTests: XCTestCase {

    private var sut: SongsViewModel!
    private var mockService: MockSongsService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockSongsService()
        sut = SongsViewModel(service: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchSongs_whenSuccessful_shouldUpdateSongs() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch songs")
        let expectedSongs = [Song.mock]
        mockService.mockResponse = SongsResponse(resultCount: 1, results: expectedSongs)
        
        // When
        sut.fetchSongs()
        
        // Then
        sut.$songs
            .dropFirst()
            .sink { songs in
                XCTAssertEqual(songs.count, expectedSongs.count)
                XCTAssertEqual(songs.first?.trackName, expectedSongs.first?.trackName)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchSongs_whenError_shouldUpdateError() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch error")
        let expectedError = NSError(domain: "test", code: 0)
        mockService.mockError = expectedError
        
        // When
        sut.fetchSongs()
        
        // Then
        sut.$error
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_searchText_whenChanged_shouldResetAndFetch() {
        // Given
        let expectation = XCTestExpectation(description: "Search text changed")
        let expectedSongs = [Song.mock]
        mockService.mockResponse = SongsResponse(resultCount: 1, results: expectedSongs)
        
        // When
        sut.searchText = "test"
        
        // Then
        // First verify that songs are reset
        XCTAssertTrue(sut.songs.isEmpty)
        
        // Then verify that fetch is called and results are updated
        sut.$songs
            .dropFirst()
            .sink { songs in
                XCTAssertEqual(songs.count, expectedSongs.count)
                XCTAssertEqual(songs.first?.trackName, expectedSongs.first?.trackName)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchSongs_whenLoading_shouldNotFetchAgain() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch once")
        expectation.expectedFulfillmentCount = 1
        
        // When
        sut.fetchSongs()
        sut.fetchSongs() // Second call while loading
        
        // Then
        mockService.fetchCallCount = 0
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 2.0)
    }
}

// MARK: - Mock Service
private class MockSongsService: SongsServiceProtocol {
    var mockResponse: SongsResponse?
    var mockError: Error?
    var fetchCallCount = 0
    
    func fetchSongs(query: String, limit: Int) -> AnyPublisher<SongsResponse, Error> {
        fetchCallCount += 1
        
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

extension Song {
    static let mock = Song(trackId: 1,
                           collectionId: 123,
                           artistName: "Artist",
                           trackName: "Music",
                           trackTimeMillis: 12344)
}

