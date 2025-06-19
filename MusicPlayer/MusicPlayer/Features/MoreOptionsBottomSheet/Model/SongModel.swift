//
//  SongBottomSheet.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import Foundation

struct SongBottomSheet: Identifiable {

    let id: UUID
    let title: String
    let artist: String
    let collectionId: Int

    init(id: UUID = UUID(), title: String, artist: String, collectionId: Int) {
        self.id = id
        self.title = title
        self.artist = artist
        self.collectionId = collectionId
    }
} 
