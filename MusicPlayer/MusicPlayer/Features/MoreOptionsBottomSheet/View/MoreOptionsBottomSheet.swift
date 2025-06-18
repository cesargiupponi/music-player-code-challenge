//
//  MoreOptionsBottomSheet.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import SwiftUI

struct MoreOptionsBottomSheet: View {

    @StateObject private var viewModel: MoreOptionsViewModel
    var onOpenAlbum: () -> Void

    init(song: SongBottomSheet,
         onOpenAlbum: @escaping () -> Void) {
        self.onOpenAlbum = onOpenAlbum
        _viewModel = StateObject(wrappedValue: MoreOptionsViewModel(song: song))
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Text(viewModel.song.title)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)
                Text(viewModel.song.artist)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray)
            }
            .padding(.top, 28)

            Button(action: {
                onOpenAlbum()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "music.note.list")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                    Text("Open album")
                        .foregroundStyle(Color.white)
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
            }
        }
        .background(Color(.sRGB, white: 0.13, opacity: 1.0))
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    MoreOptionsBottomSheet(
        song: SongBottomSheet(
            title: "Something",
            artist: "Artist",
            collectionId: 123
        ),
        onOpenAlbum: {}
    )
}
