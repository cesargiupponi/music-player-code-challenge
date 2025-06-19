//
//  SongPlayerView.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import SwiftUI

struct SongPlayerView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var progress: Double = 0.0
    @State private var bottomSheetHeight: CGFloat = .zero
    @State private var isShowingBottomSheet = false
    @State private var showAlbum = false

    @StateObject private var viewModel: SongPlayerViewModel

    var playlist: [Song]

    init(song: Song, playlist: [Song]) {
        self.playlist = playlist
        _viewModel = StateObject(wrappedValue: SongPlayerViewModel(song: song, playlist: playlist))
    }

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
                    Text(viewModel.song.trackName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                    Text(viewModel.song.artistName)
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

                VStack {
                    SmallThumbSlider(value: $progress, range: 0...Double(viewModel.trackDuration))
                    HStack {
                        Text("\(Int(progress).convertToTime())")
                            .font(.caption)
                            .foregroundStyle(Color.white)
                        Spacer()
                        Text(viewModel.trackDuration.convertToTime())
                            .font(.caption)
                            .foregroundStyle(Color.white)
                    }
                }
                .padding(.horizontal, 20)

                HStack(spacing: 40) {
                    Button(action: {
                        viewModel.previous()
                    }) {
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
                        viewModel.next()
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
        .onAppear {
            viewModel.setupPlaylist()
        }
        .sheet(isPresented: $isShowingBottomSheet) {
            let songBottomSheet = SongBottomSheet(title: viewModel.song.trackName,
                                                  artist: viewModel.song.artistName,
                                                  collectionId: viewModel.song.collectionId)
            MoreOptionsBottomSheet(song: songBottomSheet, onOpenAlbum: {
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
                AlbumView(collectionId: viewModel.song.collectionId)
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
    SongPlayerView(song: Song(trackId: 1,
                              collectionId: 1234,
                              artistName: "Artist",
                              trackName: "Track",
                              trackTimeMillis: 120000),
                    playlist: []
    )
}
