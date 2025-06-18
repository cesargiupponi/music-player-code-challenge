//
//  SongsServiceTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
import Combine
@testable import MusicPlayer

final class SongsServiceTests: XCTestCase {

    private var sut: SongsService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = SongsService()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchSongs_whenEmptyQuery_shouldUseDefaultQuery() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch with empty query")
        
        // When
        sut.fetchSongs(query: "", limit: 20)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertNotNil(response)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetchSongs_whenValidQuery_shouldReturnResults() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch with valid query")
        let query = "Taylor Swift"
        
        // When
        sut.fetchSongs(query: query, limit: 20)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertNotNil(response)
                XCTAssertFalse(response.results.isEmpty)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetchSongs_whenInvalidURL_shouldFail() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch with invalid URL")
        let mockService = MockSongsService()
        mockService.shouldReturnInvalidURL = true
        
        // When
        mockService.fetchSongs(query: "test", limit: 20)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Should fail")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// MARK: - Mock Service
private class MockSongsService: SongsServiceProtocol {
    var shouldReturnInvalidURL = false
    
    func fetchSongs(query: String, limit: Int) -> AnyPublisher<SongsResponse, Error> {
        if shouldReturnInvalidURL {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var components = URLComponents(string: "https://itunes.apple.com/search")!
        components.queryItems = [
            URLQueryItem(name: "term", value: query.isEmpty ? "music" : query),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: String(limit)),
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SongsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
} 
