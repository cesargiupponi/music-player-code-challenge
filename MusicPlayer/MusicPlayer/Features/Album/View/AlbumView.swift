//
//  AlbumView.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import SwiftUI

struct AlbumView: View {
    @StateObject private var viewModel: AlbumViewModel
    
    init(collectionId: Int) {
        _viewModel = StateObject(wrappedValue: AlbumViewModel(collectionId: collectionId))
    }
    
    var body: some View {
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
                    
                case .loaded, .loading:
                    // Show content
                    VStack(alignment: .leading, spacing: 20) {
                        Text(viewModel.albumName)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 20)
                        
                        // Show songs list
                        List(viewModel.songs) { song in
                            HStack(spacing: 16) {
                                ZStack {
                                    Image(.songIconSmall)
                                        .foregroundStyle(Color.white)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    if let trackName = song.trackName {
                                        Text(trackName)
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: 18, weight: .medium))
                                    }
                                    Text(song.artistName)
                                        .foregroundStyle(Color.gray)
                                        .font(.system(size: 14))
                                }
                                Spacer()
                            }
                            .listRowBackground(Color.black)
                        }
                        .listStyle(.plain)
                    }
                    
                case .empty:
                    // This case is not used in AlbumView as requested
                    EmptyView()
                }
            }
        }
        .task {
            await viewModel.fetchAlbumSongs()
        }
    }
}

#Preview {
    AlbumView(collectionId: 576670451)
} 
