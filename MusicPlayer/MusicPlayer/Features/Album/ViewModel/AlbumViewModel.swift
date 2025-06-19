//
//  AlbumViewModel.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import Foundation

@MainActor
final class AlbumViewModel: ObservableObject {
    @Published private(set) var songs: [AlbumSong] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?
    @Published var albumName: String = ""

    private let service: AlbumServiceProtocol
    private let collectionId: Int

    init(collectionId: Int, service: AlbumServiceProtocol = AlbumService()) {
        self.collectionId = collectionId
        self.service = service
    }

    func fetchAlbumSongs() async {
        isLoading = true
        error = nil
        
        do {
            let response = try await service.fetchAlbumSongs(collectionId: collectionId)
            
            // The first result is the album, the rest are songs
            if let album = response.results.first(where: { $0.wrapperType == "collection" }) {
                albumName = album.collectionName ?? ""
            }
            songs = response.results.filter { $0.wrapperType == "track" }
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 
