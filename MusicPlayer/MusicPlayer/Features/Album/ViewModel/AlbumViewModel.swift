//
//  AlbumViewModel.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import Foundation
import Combine

final class AlbumViewModel: ObservableObject {
    @Published private(set) var songs: [AlbumSong] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?
    @Published var albumName: String = ""

    private let service: AlbumServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let collectionId: Int

    init(collectionId: Int, service: AlbumServiceProtocol = AlbumService()) {
        self.collectionId = collectionId
        self.service = service
        fetchAlbumSongs()
    }

    func fetchAlbumSongs() {
        isLoading = true
        service.fetchAlbumSongs(collectionId: collectionId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.error = error
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                // The first result is the album, the rest are songs
                if let album = response.results.first(where: { $0.wrapperType == "collection" }) {
                    self.albumName = album.collectionName ?? ""
                }
                self.songs = response.results.filter { $0.wrapperType == "track" }
            })
            .store(in: &cancellables)
    }
} 
