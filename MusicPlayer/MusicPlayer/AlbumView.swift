//
//  AlbumView.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import SwiftUI

struct AlbumView: View {

    let songs = Array(repeating: Song(title: "Something", artist: "Artist"), count: 50)

    var body: some View {

        ZStack {

            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {

                Text("Album Name")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)

                List(songs) { song in

                    HStack(spacing: 16) {
                        ZStack {
                            Image(.songIconSmall)
                                .foregroundStyle(Color.white)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(song.title)
                                .foregroundStyle(Color.white)
                                .font(.system(size: 18, weight: .medium))
                            Text(song.artist)
                                .foregroundStyle(Color.gray)
                                .font(.system(size: 14))
                        }

                        Spacer()
                    }
                    .listRowBackground(Color.black)
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    AlbumView()
}
