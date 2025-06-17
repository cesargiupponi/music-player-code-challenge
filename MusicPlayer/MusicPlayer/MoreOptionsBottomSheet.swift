//
//  MoreOptionsBottomSheet.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import SwiftUI

struct MoreOptionsBottomSheet: View {

    var onOpenAlbum: () -> Void

    var body: some View {

        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Text("Something")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)
                Text("Artist")
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
    MoreOptionsBottomSheet(onOpenAlbum: {})
}
