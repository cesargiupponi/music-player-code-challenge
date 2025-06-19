//
//  SongsViewModel.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import Foundation

@MainActor
final class SongsViewModel: ObservableObject {
    @Published private(set) var songs: [Song] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?
    @Published var searchText: String = "" {
        didSet {
            Task {
                await resetAndFetch()
            }
        }
    }

    private let service: SongsServiceProtocol
    private var canLoadMore = true
    private var pageSize = 20
    private let pageSizeIncrement = 20

    init(service: SongsServiceProtocol = SongsService()) {
        self.service = service
    }

    func fetchSongs() async {
        guard !isLoading, canLoadMore else { return }
        isLoading = true
        error = nil
        
        do {
            let response = try await service.fetchSongs(query: searchText, limit: pageSize)
            songs = response.results
            canLoadMore = response.resultCount > pageSize
            pageSize += pageSizeIncrement
        } catch {
            self.error = error
        }
        
        isLoading = false
    }

    private func resetAndFetch() async {
        songs = []
        canLoadMore = true
        pageSize = 20
        await fetchSongs()
    }
} 
