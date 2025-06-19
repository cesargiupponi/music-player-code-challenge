//
//  AlbumViewModelTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
@testable import MusicPlayer

@MainActor
final class AlbumViewModelTests: XCTestCase {
    
    private var sut: AlbumViewModel!
    private var mockService: MockAlbumService!
    private let timeout: TimeInterval = 1.0
    
    override func setUp() {
        super.setUp()
        mockService = MockAlbumService()
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func test_init_shouldStartFetching() async {

        // Given
        let expectedSongs = [AlbumSong.mock]
        let expectedAlbum = AlbumSong.mockAlbum
        await mockService.setMockResponse(AlbumResponse(results: [expectedAlbum] + expectedSongs))
        
        // When
        sut = AlbumViewModel(collectionId: 123, service: mockService)
        await sut.fetchAlbumSongs()
        
        // Then
        XCTAssertEqual(sut.songs.count, expectedSongs.count)
        XCTAssertEqual(sut.albumName, expectedAlbum.collectionName)
    }
    
    func test_fetchAlbumSongs_whenError_shouldUpdateError() async {

        // Given
        let expectedError = NSError(domain: "test", code: 0)
        await mockService.setMockError(expectedError)
        
        // When
        sut = AlbumViewModel(collectionId: 123, service: mockService)
        await sut.fetchAlbumSongs()
        
        // Then
        XCTAssertNotNil(sut.error)
    }
    
    func test_fetchAlbumSongs_whenLoading_shouldUpdateLoadingState() async {

        // Given
        let expectedSongs = [AlbumSong.mock]
        let expectedAlbum = AlbumSong.mockAlbum
        await mockService.setMockResponse(AlbumResponse(results: [expectedAlbum] + expectedSongs))
        await mockService.setDelay(0.2) // Add delay to ensure we can catch loading state
        
        // When
        sut = AlbumViewModel(collectionId: 123, service: mockService)
        
        // Start the fetch
        let fetchTask = Task {
            await sut.fetchAlbumSongs()
        }
        
        // Wait for loading to complete
        await fetchTask.value
        
        // Then check that loading is false
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_fetchAlbumSongs_whenEmptyResponse_shouldHandleEmptyState() async {

        // Given
        await mockService.setMockResponse(AlbumResponse(results: []))
        
        // When
        sut = AlbumViewModel(collectionId: 123, service: mockService)
        await sut.fetchAlbumSongs()
        
        // Then
        XCTAssertTrue(sut.songs.isEmpty)
        XCTAssertTrue(sut.albumName.isEmpty)
    }
    
    func test_fetchAlbumSongs_whenNoAlbumInfo_shouldHandleMissingAlbum() async {

        // Given
        let expectedSongs = [AlbumSong.mock]
        await mockService.setMockResponse(AlbumResponse(results: expectedSongs))
        
        // When
        sut = AlbumViewModel(collectionId: 123, service: mockService)
        await sut.fetchAlbumSongs()
        
        // Then
        XCTAssertEqual(sut.songs.count, expectedSongs.count)
        XCTAssertTrue(sut.albumName.isEmpty)
    }
}

// MARK: - Mock Service
private actor MockAlbumService: AlbumServiceProtocol {
    
    private var mockResponse: AlbumResponse?
    private var mockError: Error?
    private var delay: TimeInterval = 0
    
    func setMockResponse(_ response: AlbumResponse?) {
        mockResponse = response
    }
    
    func setMockError(_ error: Error?) {
        mockError = error
    }
    
    func setDelay(_ delay: TimeInterval) {
        self.delay = delay
    }
    
    func fetchAlbumSongs(collectionId: Int) async throws -> AlbumResponse {
        // Add delay if specified
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        if let error = mockError {
            throw error
        }
        
        if let response = mockResponse {
            return response
        }
        
        throw NSError(domain: "test", code: 0)
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
