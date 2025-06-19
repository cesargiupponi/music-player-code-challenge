//
//  MusicPlayerEmptyStateView.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import SwiftUI

struct MusicPlayerEmptyStateView: View {

    let searchText: String

    var body: some View {
        VStack(spacing: 24) {

            Image(systemName: "music.note.list")
                .font(.system(size: 48))
                .foregroundStyle(Color.gray)
            
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.system(size: 16))
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    
    private var title: String {
        if searchText.isEmpty {
            return "No Songs Found"
        } else {
            return "No Results Found"
        }
    }
    
    private var message: String {
        if searchText.isEmpty {
            return "Start by searching for your favorite artists or songs to discover new music."
        } else {
            return "We couldn't find any songs matching \"\(searchText)\". Try searching for something else."
        }
    }
}

#Preview {
    MusicPlayerEmptyStateView(
        searchText: "Taylor Swift"
    )
} 
