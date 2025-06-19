//
//  SongPlayerViewModel.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import Foundation
import Combine

@MainActor
final class SongPlayerViewModel: ObservableObject {
    
    @Published var song: Song
    private var playlist: [Song] = []
    private var currentIndex: Int = 0
    
    private var cancellables = Set<AnyCancellable>()

    var trackDuration: Int {
        song.trackTimeMillis ?? 0
    }
    
    var hasNext: Bool {
        !playlist.isEmpty && currentIndex < playlist.count - 1
    }
    
    var hasPrevious: Bool {
        !playlist.isEmpty && currentIndex > 0
    }

    init(song: Song, playlist: [Song] = []) {
        self.song = song
        self.playlist = playlist
        setupPlaylist()
    }
    
    func next() {
        guard hasNext else { return }
        
        currentIndex += 1
        song = playlist[currentIndex]
    }
    
    func previous() {
        guard hasPrevious else { return }
        
        currentIndex -= 1
        song = playlist[currentIndex]
    }
    
    private func setupPlaylist() {
        // Ensure the playlist is not empty and contains the current song
        guard !playlist.isEmpty else { return }
        
        // Find the current song in the playlist
        if let index = playlist.firstIndex(where: { $0.trackId == song.trackId }) {
            currentIndex = index
        } else {
            // If the current song is not in the playlist, add it at the beginning
            playlist.insert(song, at: 0)
            currentIndex = 0
        }
    }
}
