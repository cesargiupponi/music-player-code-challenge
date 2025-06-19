//
//  MusicPlayerManager.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import Foundation
import Combine

@MainActor
final class MusicPlayerManager: ObservableObject {
    static let shared = MusicPlayerManager()
    
    @Published private(set) var currentSong: Song?
    @Published private(set) var playlist: [Song] = []
    @Published private(set) var currentIndex: Int = -1
    
    private init() {}
    
    func setPlaylist(_ songs: [Song], startingFrom song: Song? = nil) {
        playlist = songs
        
        if let song = song, let index = songs.firstIndex(where: { $0.trackId == song.trackId }) {
            currentIndex = index
            currentSong = songs[index]
        } else {
            currentIndex = 0
            currentSong = songs.first
        }
    }
    
    func next() {
        guard !playlist.isEmpty else { return }
        
        currentIndex = (currentIndex + 1) % playlist.count
        currentSong = playlist[currentIndex]
    }
    
    func previous() {
        guard !playlist.isEmpty else { return }
        
        currentIndex = currentIndex > 0 ? currentIndex - 1 : playlist.count - 1
        currentSong = playlist[currentIndex]
    }    
}
