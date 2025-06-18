//
//  MoreOptionsViewModelTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
import Combine
@testable import MusicPlayer

final class MoreOptionsViewModelTests: XCTestCase {

    private var sut: MoreOptionsViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    @MainActor
    override func setUp() {
        super.setUp()
        sut = MoreOptionsViewModel(song: .mock)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    @MainActor
    func test_init_shouldSetInitialSong() {
        // Given
        let song = SongBottomSheet.mock
        
        // When
        let viewModel = MoreOptionsViewModel(song: song)
        
        // Then
        XCTAssertEqual(viewModel.song.title, song.title)
        XCTAssertEqual(viewModel.song.artist, song.artist)
        XCTAssertEqual(viewModel.song.collectionId, song.collectionId)
    }
    
    @MainActor
    func test_song_whenUpdated_shouldPublishChanges() {
        // Given
        let expectation = XCTestExpectation(description: "Song updated")
        let newSong = SongBottomSheet(
            title: "New Title",
            artist: "New Artist",
            collectionId: 456
        )
        
        // When
        sut.$song
            .dropFirst()
            .sink { song in
                // Then
                XCTAssertEqual(song.title, newSong.title)
                XCTAssertEqual(song.artist, newSong.artist)
                XCTAssertEqual(song.collectionId, newSong.collectionId)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.song = newSong
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Data
extension SongBottomSheet {
    static let mock = SongBottomSheet(
        title: "Test Song",
        artist: "Test Artist",
        collectionId: 123
    )
} 
