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
    @Published private(set) var state: MusicPlayerViewState = .idle
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
        state = .loading
        
        do {
            let response = try await service.fetchSongs(query: searchText, limit: pageSize)
            
            if songs.isEmpty {

                songs = response.results

                if response.results.isEmpty {
                    state = .empty
                } else {
                    state = .loaded
                }
            } else {
                songs.append(contentsOf: response.results)
                state = .loaded
            }
            
            canLoadMore = response.resultCount > pageSize
            pageSize += pageSizeIncrement
        } catch {
            self.error = error
            state = .error(error)
        }
        
        isLoading = false
    }
    
    func retry() async {
        error = nil
        state = .idle
        await resetAndFetch()
    }

    private func resetAndFetch() async {
        songs = []
        canLoadMore = true
        pageSize = 20
        await fetchSongs()
    }
} 
