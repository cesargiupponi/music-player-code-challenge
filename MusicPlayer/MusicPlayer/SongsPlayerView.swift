//
//  SongsPlayerView.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import SwiftUI

struct SongsPlayerView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var progress: Double = 0.0
    @State private var bottomSheetHeight: CGFloat = .zero
    @State private var isShowingBottomSheet = false
    @State private var showAlbum = false

    var body: some View {
        ZStack {

            Color.black.edgesIgnoringSafeArea(.all)

            VStack {

                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(.leftAction)
                            .foregroundStyle(Color.white)
                            .font(.title2)
                    }
                    Spacer()
                    Button(action: {
                        isShowingBottomSheet.toggle()
                    }) {
                        Image(.moreOptions)
                            .foregroundStyle(Color.white)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Spacer()

                ZStack {
                    Image(.songIconBig)
                }
                .padding(.bottom, 40)

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Something")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                    Text("Artist")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

                VStack {
                    SmallThumbSlider(value: $progress, range: 0...200)
                    HStack {
                        Text("0:00")
                            .font(.caption)
                            .foregroundStyle(Color.white)
                        Spacer()
                        Text("-3:20")
                            .font(.caption)
                            .foregroundStyle(Color.white)
                    }
                }
                .padding(.horizontal, 20)

                HStack(spacing: 40) {
                    Button(action: {}) {
                        Image(.backward)
                            .font(.title)
                            .foregroundStyle(Color.white)
                    }
                    Button(action: {}) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 60, height: 60)
                            Image(.playResume)
                                .font(.title)
                                .foregroundStyle(Color.black)
                        }
                    }
                    Button(action: {

                    }) {
                        Image(.forward)
                            .font(.title)
                            .foregroundStyle(Color.white)
                    }
                }
                .padding(.top, 20)
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isShowingBottomSheet) {
            MoreOptionsBottomSheet(onOpenAlbum: {
                showAlbum = true
            })
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                bottomSheetHeight = newHeight
            }
            .presentationDetents([.height(bottomSheetHeight)])
            .presentationDragIndicator(.visible)
            .sheet(isPresented: $showAlbum) {
                AlbumView()
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

struct SmallThumbSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 4)
                Capsule()
                    .fill(Color.white)
                    .frame(width: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width, height: 4)
                Circle()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
                    .offset(x: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width - 7)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let percent = min(max(gesture.location.x / geometry.size.width, 0), 1)
                                value = range.lowerBound + percent * (range.upperBound - range.lowerBound)
                            }
                    )
            }
        }
        .frame(height: 20)
    }
}

#Preview {
    SongsPlayerView()
}
