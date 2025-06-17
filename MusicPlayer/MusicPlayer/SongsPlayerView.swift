//
//  SongsPlayerView.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import SwiftUI

struct SongsPlayerView: View {

    @State private var progress: Double = 0.0
    @State private var bottomSheetHeight: CGFloat = .zero
    @State private var isShowingBottomSheet = false
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
        ZStack {

            Color.black.edgesIgnoringSafeArea(.all)

            VStack {

                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(.leftAction)
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    Spacer()
                    Button(action: {
                        isShowingBottomSheet.toggle()
                    }) {
                        Image(.moreOptions)
                            .foregroundColor(.white)
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
                        .foregroundColor(.white)
                    Text("Artist")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

                VStack {
                    SmallThumbSlider(value: $progress, range: 0...200)
                    HStack {
                        Text("0:00")
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                        Text("-3:20")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)

                HStack(spacing: 40) {
                    Button(action: {}) {
                        Image(.backward)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Button(action: {}) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 60, height: 60)
                            Image(.playResume)
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    Button(action: {}) {
                        Image(.forward)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 20)
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isShowingBottomSheet) {
            MoreOptionsBottomSheet()
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
