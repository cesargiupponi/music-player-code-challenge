//
//  SongsServiceTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
@testable import MusicPlayer

final class SongsServiceTests: XCTestCase {

    private var sut: SongsService!
    private let timeout: TimeInterval = 1.0
    
    override func setUp() {
        super.setUp()
        sut = SongsService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetchSongs_whenEmptyQuery_shouldUseDefaultQuery() async throws {

        // Given
        let query = ""
        let limit = 20
        
        // When
        let response = try await sut.fetchSongs(query: query, limit: limit)
        
        // Then
        XCTAssertNotNil(response)
    }
    
    func test_fetchSongs_whenValidQuery_shouldReturnResults() async throws {

        // Given
        let query = "Taylor Swift"
        let limit = 20
        
        // When
        let response = try await sut.fetchSongs(query: query, limit: limit)
        
        // Then
        XCTAssertNotNil(response)
        XCTAssertFalse(response.results.isEmpty)
    }
    
    func test_fetchSongs_whenInvalidURL_shouldFail() async {

        // Given
        let mockService = MockSongsService()
        await mockService.setMockError(URLError(.badURL))
        
        // When/Then
        do {
            _ = try await mockService.fetchSongs(query: "test", limit: 20)
            XCTFail("Should fail")
        } catch {
            // Test passes if we get here
        }
    }
    
    func test_fetchSongs_whenNetworkError_shouldFail() async {

        // Given
        let mockService = MockSongsService()
        await mockService.setMockError(URLError(.networkConnectionLost))
        
        // When/Then
        do {
            _ = try await mockService.fetchSongs(query: "test", limit: 20)
            XCTFail("Should fail")
        } catch {
            // Test passes if we get here
        }
    }
    
    func test_fetchSongs_whenMockResponse_shouldReturnMockData() async throws {

        // Given
        let mockService = MockSongsService()
        let mockResponse = SongsResponse(resultCount: 1, results: [Song.mock])
        await mockService.setMockResponse(mockResponse)
        
        // When
        let response = try await mockService.fetchSongs(query: "test", limit: 20)
        
        // Then
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results.first?.trackName, Song.mock.trackName)
    }
    
    func test_fetchSongs_whenDelay_shouldRespectDelay() async throws {

        // Given
        let mockService = MockSongsService()
        let mockResponse = SongsResponse(resultCount: 10, results: [Song.mock])
        await mockService.setMockResponse(mockResponse)
        await mockService.setDelay(0.1) // 100ms delay
        
        let startTime = Date()
        
        // When
        _ = try await mockService.fetchSongs(query: "test", limit: 20)
        
        // Then
        let elapsedTime = Date().timeIntervalSince(startTime)
        XCTAssertGreaterThanOrEqual(elapsedTime, 0.1, "Should respect the delay")
    }
    
    func test_fetchSongs_whenCancelled_shouldNotComplete() async {

        // Given
        let query = "test"
        let limit = 20
        
        // When/Then
        let task = Task {
            try await sut.fetchSongs(query: query, limit: limit)
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
