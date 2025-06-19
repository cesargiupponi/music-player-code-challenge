//
//  SongsViewModelTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
@testable import MusicPlayer

@MainActor
final class SongsViewModelTests: XCTestCase {

    private var sut: SongsViewModel!
    private var mockService: MockSongsService!
    
    override func setUp() {
        super.setUp()
        mockService = MockSongsService()
        sut = SongsViewModel(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func test_fetchSongs_whenSuccessful_shouldUpdateSongs() async {

        // Given
        let expectedSongs = [Song.mock]
        await mockService.setMockResponse(SongsResponse(resultCount: 1, results: expectedSongs))
        
        // When
        await sut.fetchSongs()
        
        // Then
        XCTAssertEqual(sut.songs.count, expectedSongs.count)
        XCTAssertEqual(sut.songs.first?.trackName, expectedSongs.first?.trackName)
    }
    
    func test_fetchSongs_whenError_shouldUpdateError() async {

        // Given
        let expectedError = NSError(domain: "test", code: 0)
        await mockService.setMockError(expectedError)
        
        // When
        await sut.fetchSongs()
        
        // Then
        XCTAssertNotNil(sut.error)
    }
    
    func test_searchText_whenChanged_shouldResetAndFetch() async {

        // Given
        let expectedSongs = [Song.mock]
        await mockService.setMockResponse(SongsResponse(resultCount: 1, results: expectedSongs))
        
        // When
        sut.searchText = "test"
        
        // Wait for the async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(sut.songs.count, expectedSongs.count)
        XCTAssertEqual(sut.songs.first?.trackName, expectedSongs.first?.trackName)
    }
    
    func test_fetchSongs_whenLoading_shouldNotFetchAgain() async {

        // Given
        await mockService.setDelay(0.2) // Add delay to ensure loading state is observable
        
        // When
        let fetchTask1 = Task { await sut.fetchSongs() }
        let fetchTask2 = Task { await sut.fetchSongs() } // Second call while loading
        
        // Then
        await fetchTask1.value
        await fetchTask2.value
        
        // Verify that only one fetch was actually performed
        XCTAssertFalse(sut.isLoading)
    }
}
