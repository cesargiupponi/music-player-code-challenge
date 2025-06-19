//
//  SongPlayerViewModelTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
import Combine
@testable import MusicPlayer

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
    
    func test_trackDuration_whenNil_shouldReturnZero() {

        // Given
        let song = Song(trackId: 1,
                       collectionId: 123,
                       artistName: "Artist",
                       trackName: "Music",
                       trackTimeMillis: nil)
        sut = SongPlayerViewModel(song: song)
        
        // When
        let duration = sut.trackDuration
        
        // Then
        XCTAssertEqual(duration, 0)
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
} 
