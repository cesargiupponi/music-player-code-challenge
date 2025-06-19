//
//  MusicPlayerManagerTests.swift
//  MusicPlayerTests
//
//  Created by Cesar Giupponi on 18/06/25.
//

import XCTest
@testable import MusicPlayer

@MainActor
final class MusicPlayerManagerTests: XCTestCase {
    
    private var sut: MusicPlayerManager!
    
    override func setUp() {
        super.setUp()
        sut = MusicPlayerManager.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_setPlaylist_withSong_shouldSetCurrentSong() {
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        
        // When
        sut.setPlaylist(songs, startingFrom: Song.mock2)
        
        // Then
        XCTAssertEqual(sut.currentSong?.trackId, Song.mock2.trackId)
        XCTAssertEqual(sut.currentIndex, 1)
        XCTAssertEqual(sut.playlist.count, 3)
    }
    
    func test_setPlaylist_withoutSong_shouldSetFirstSong() {
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        
        // When
        sut.setPlaylist(songs)
        
        // Then
        XCTAssertEqual(sut.currentSong?.trackId, songs[0].trackId)
        XCTAssertEqual(sut.currentIndex, 0)
        XCTAssertEqual(sut.playlist.count, 3)
    }
    
    func test_next_shouldAdvanceToNextSong() {
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut.setPlaylist(songs, startingFrom: Song.mock)
        
        // When
        sut.next()
        
        // Then
        XCTAssertEqual(sut.currentSong?.trackId, songs[1].trackId)
        XCTAssertEqual(sut.currentIndex, 1)
    }
    
    func test_next_atEndOfPlaylist_shouldWrapToFirst() {
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut.setPlaylist(songs, startingFrom: Song.mock3)
        
        // When
        sut.next()
        
        // Then
        XCTAssertEqual(sut.currentSong?.trackId, songs[0].trackId)
        XCTAssertEqual(sut.currentIndex, 0)
    }
    
    func test_previous_shouldGoToPreviousSong() {
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut.setPlaylist(songs, startingFrom: Song.mock3)
        
        // When
        sut.previous()
        
        // Then
        XCTAssertEqual(sut.currentSong?.trackId, songs[1].trackId)
        XCTAssertEqual(sut.currentIndex, 1)
    }
    
    func test_previous_atBeginningOfPlaylist_shouldWrapToLast() {
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut.setPlaylist(songs, startingFrom: Song.mock)
        
        // When
        sut.previous()
        
        // Then
        XCTAssertEqual(sut.currentSong?.trackId, songs[2].trackId)
        XCTAssertEqual(sut.currentIndex, 2)
    }
}
