//
//  SongsView.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 16/06/25.
//

import SwiftUI

struct Song: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
}

struct SongsView: View {

    @State private var searchText = ""
    @State private var scrollOffset: CGFloat = 0
    @State var hasScrolled = false
    let songs = Array(repeating: Song(title: "Something", artist: "Artist"), count: 50)
    let navBarAppearence = UINavigationBarAppearance()

    init() {
        navBarAppearence.configureWithOpaqueBackground()
        navBarAppearence.backgroundColor = .black
        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = navBarAppearence
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearence
    }

    var body: some View {

        NavigationStack {

            ZStack {

                Color.black.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    List(songs) { song in
                        NavigationLink {
                            SongsPlayerView()
                        } label: {
                            HStack(spacing: 16) {
                                ZStack {
                                    Image(.songIconSmall)
                                        .foregroundColor(.white)
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(song.title)
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .medium))
                                    Text(song.artist)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                }

                                Spacer()
                            }
                        }
                        .listRowBackground(Color.black)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle(Text("Songs"))
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search")
        }
    }
}

#Preview {
    SongsView()
}
