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
    
    func test_setPlaylist_shouldSetCurrentSong() {
        
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
        sut.setPlaylist(songs)
        
        // When
        sut.next()
        
        // Then
        XCTAssertEqual(sut.currentSong?.trackId, songs[1].trackId)
        XCTAssertEqual(sut.currentIndex, 1)
    }
    
    func test_next_atEndOfPlaylist_shouldWrapToFirst() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut.setPlaylist(songs)
        
        // When
        sut.next()
        
        // Then
        XCTAssertEqual(sut.currentSong?.trackId, songs[1].trackId)
        XCTAssertEqual(sut.currentIndex, 1)
    }
    
    func test_previous_shouldGoToPreviousSong() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut.setPlaylist(songs)
        
        // When
        sut.previous()
        
        // Then
        XCTAssertEqual(sut.currentSong?.trackId, songs[2].trackId)
        XCTAssertEqual(sut.currentIndex, 2)
    }
    
    func test_previous_atBeginningOfPlaylist_shouldWrapToLast() {
        
        // Given
        let songs = [Song.mock, Song.mock2, Song.mock3]
        sut.setPlaylist(songs)
        
        // When
        sut.previous()
        
        // Then
        XCTAssertEqual(sut.currentSong?.trackId, songs[2].trackId)
        XCTAssertEqual(sut.currentIndex, 2)
    }
}

extension Song {
    static let mock2 = Song(trackId: 2,
                           collectionId: 123,
                           artistName: "Artist 2",
                           trackName: "Music 2",
                           trackTimeMillis: 180000)
    
    static let mock3 = Song(trackId: 3,
                           collectionId: 123,
                           artistName: "Artist 3",
                           trackName: "Music 3",
                           trackTimeMillis: 200000)
} 
