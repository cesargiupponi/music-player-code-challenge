//
//  SongsViewModel.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import Foundation
import Combine

struct Song: Identifiable, Decodable {
    var id: Int { trackId }
    let trackId: Int
    let artistName: String
    let collectionName: String
    let trackName: String
    let artworkUrl60: String?
    let artworkUrl100: String?
    let previewUrl: String?
    let trackViewUrl: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let primaryGenreName: String?
    let trackTimeMillis: Int?
}

final class SongsViewModel: ObservableObject {

    @Published private(set) var songs: [Song] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?
    @Published var searchText: String = "" {
        didSet {
            resetAndFetch()
        }
    }

    private let service: SongsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var canLoadMore = true
    private var pageSize = 20
    private let pageSizeIncrement = 20

    init(service: SongsServiceProtocol = SongsService()) {
        self.service = service
    }

    func fetchSongs() {
        guard !isLoading, canLoadMore else { return }
        isLoading = true
        service.fetchSongs(query: searchText, limit: pageSize)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.error = error
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.songs = response.results
                self.canLoadMore = response.resultCount > self.pageSize
                self.pageSize += self.pageSizeIncrement
            })
            .store(in: &cancellables)
    }

    private func resetAndFetch() {
        songs = []
        canLoadMore = true
        pageSize = 20
        fetchSongs()
    }
} 
