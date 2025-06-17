//
//  MoreOptionsBottomSheet.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import SwiftUI

struct MoreOptionsBottomSheet: View {

    var body: some View {

        VStack(spacing: 24) {

            VStack(spacing: 12) {

                Text("Something")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Artist")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.top, 28)

            Button(action: {}) {
                HStack(spacing: 12) {
                Image(systemName: "music.note.list")
                    .font(.title2)
                    .foregroundColor(.white)
                Text("Open album")
                    .foregroundColor(.white)
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
    MoreOptionsBottomSheet()
}
