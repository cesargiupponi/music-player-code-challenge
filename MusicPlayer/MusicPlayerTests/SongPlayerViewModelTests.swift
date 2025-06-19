//
//  SongPlayerViewModelTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
import Combine
@testable import MusicPlayer

@MainActor
final class SongPlayerViewModelTests: XCTestCase {
    private var sut: SongPlayerViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = SongPlayerViewModel(song: .mock)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_init_shouldSetInitialSong() {

        // Given
        let song = Song.mock
        
        // When
        let viewModel = SongPlayerViewModel(song: song)
        
        // Then
        XCTAssertEqual(viewModel.song.trackId, song.trackId)
        XCTAssertEqual(viewModel.song.trackName, song.trackName)
        XCTAssertEqual(viewModel.song.artistName, song.artistName)
    }
    
    func test_trackDuration_shouldReturnCorrectDuration() {

        // Given
        let expectedDuration = 12344
        
        // When
        let duration = sut.trackDuration
        
        // Then
        XCTAssertEqual(duration, expectedDuration)
    }
    
    func test_song_whenUpdated_shouldPublishChanges() {

        // Given
        let expectation = XCTestExpectation(description: "Song updated")
        let newSong = Song(trackId: 2,
                          collectionId: 456,
                          artistName: "New Artist",
                          trackName: "New Music",
                          trackTimeMillis: 54321)
        
        // When
        sut.$song
            .dropFirst()
            .sink { song in
                // Then
                XCTAssertEqual(song.trackId, newSong.trackId)
                XCTAssertEqual(song.trackName, newSong.trackName)
                XCTAssertEqual(song.artistName, newSong.artistName)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.song = newSong
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_init_withPlaylist_shouldSetCurrentSong() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        let currentSong = Song.mock2
        
        // When
        sut = SongPlayerViewModel(song: currentSong, playlist: songs)
        
        // Then
        XCTAssertEqual(sut.song.trackId, currentSong.trackId)
        XCTAssertTrue(sut.hasNext)
        XCTAssertTrue(sut.hasPrevious)
    }
    
    func test_next_shouldAdvanceToNextSong() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut = SongPlayerViewModel(song: Song.mock, playlist: songs)
        
        // When
        sut.next()
        
        // Then
        XCTAssertEqual(sut.song.trackId, Song.mock2.trackId)
        XCTAssertTrue(sut.hasNext)
        XCTAssertTrue(sut.hasPrevious)
    }
    
    func test_next_atEndOfPlaylist_shouldNotAdvance() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut = SongPlayerViewModel(song: Song.mock3, playlist: songs)
        
        // When
        sut.next()
        
        // Then
        XCTAssertEqual(sut.song.trackId, Song.mock3.trackId) // Should stay the same
        XCTAssertFalse(sut.hasNext)
        XCTAssertTrue(sut.hasPrevious)
    }
    
    func test_previous_shouldGoToPreviousSong() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut = SongPlayerViewModel(song: Song.mock3, playlist: songs)
        
        // When
        sut.previous()
        
        // Then
        XCTAssertEqual(sut.song.trackId, Song.mock2.trackId)
        XCTAssertTrue(sut.hasNext)
        XCTAssertTrue(sut.hasPrevious)
    }
    
    func test_previous_atBeginningOfPlaylist_shouldNotGoBack() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut = SongPlayerViewModel(song: Song.mock, playlist: songs)
        
        // When
        sut.previous()
        
        // Then
        XCTAssertEqual(sut.song.trackId, Song.mock.trackId) // Should stay the same
        XCTAssertTrue(sut.hasNext)
        XCTAssertFalse(sut.hasPrevious)
    }
    
    func test_hasNext_withMultipleSongs_shouldReturnTrue() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut = SongPlayerViewModel(song: Song.mock, playlist: songs)
        
        // When & Then
        XCTAssertTrue(sut.hasNext)
    }
    
    func test_hasPrevious_withMultipleSongs_shouldReturnTrue() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut = SongPlayerViewModel(song: Song.mock2, playlist: songs)
        
        // When & Then
        XCTAssertTrue(sut.hasPrevious)
    }
    
    func test_hasNext_atLastSong_shouldReturnFalse() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut = SongPlayerViewModel(song: Song.mock3, playlist: songs)
        
        // When & Then
        XCTAssertFalse(sut.hasNext)
    }
    
    func test_hasPrevious_atFirstSong_shouldReturnFalse() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut = SongPlayerViewModel(song: Song.mock, playlist: songs)
        
        // When & Then
        XCTAssertFalse(sut.hasPrevious)
    }
}
