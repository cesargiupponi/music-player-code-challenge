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
    var playlist: [Song] = []
    
    private let musicPlayerManager = MusicPlayerManager.shared
    private var cancellables = Set<AnyCancellable>()

    var trackDuration: Int {
        song.trackTimeMillis ?? 0
    }
    
    init(song: Song, playlist: [Song] = []) {
        self.song = song
        self.playlist = playlist
        setupBindings()
    }
    
    func next() {
        musicPlayerManager.next()
    }
    
    func previous() {
        musicPlayerManager.previous()
    }
    
    private func setupBindings() {
        musicPlayerManager.$currentSong
            .compactMap { $0 }
            .sink { [weak self] newSong in
                self?.song = newSong
            }
            .store(in: &cancellables)
    }

    func setupPlaylist() {
        playlist.insert(song, at: 0)
        MusicPlayerManager.shared.setPlaylist(playlist)
    }
}
