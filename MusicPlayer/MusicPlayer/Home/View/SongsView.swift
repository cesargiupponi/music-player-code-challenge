//
//  SongsView.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 16/06/25.
//

import SwiftUI

struct SongsView: View {
    @StateObject private var viewModel = SongsViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    switch viewModel.state {
                    case .idle, 
                            .loading where viewModel.songs.isEmpty:
                        VStack {
                            Spacer()
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .tint(Color.white)
                            Spacer()
                        }
                        
                    case .error(let error):
                        MusicPlayerErrorView(error: error) {
                            Task {
                                await viewModel.retry()
                            }
                        }
                        
                    case .empty:
                        MusicPlayerEmptyStateView(searchText: viewModel.searchText)
                        
                    case .loaded, .loading:
                        songsList
                    }
                }
            }
            .task {
                await viewModel.fetchSongs()
            }
            .listStyle(.plain)
            .navigationTitle(Text("Songs"))
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search")
            .onSubmit(of: .search) {
                viewModel.searchText = searchText
            }
        }
    }
    
    private var songsList: some View {
        List {
            ForEach(viewModel.songs.indices, id: \.self) { index in
                let song = viewModel.songs[index]
                NavigationLink(destination: SongPlayerView(song: song)) {
                    HStack(spacing: 16) {
                        ZStack {
                            Image(.songIconSmall)
                                .foregroundStyle(Color.white)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(song.trackName)
                                .foregroundStyle(Color.white)
                                .font(.system(size: 18, weight: .medium))
                            Text(song.artistName)
                                .foregroundStyle(Color.gray)
                                .font(.system(size: 14))
                        }

                        Spacer()
                    }
                }
                .listRowBackground(Color.black)
                .onAppear {
                    if index == viewModel.songs.count - 1 {
                        Task {
                            await viewModel.fetchSongs()
                        }
                    }
                }
            }
        }
        .refreshable {
            viewModel.searchText = ""
        }
    }
}

#Preview {
    SongsView()
}
