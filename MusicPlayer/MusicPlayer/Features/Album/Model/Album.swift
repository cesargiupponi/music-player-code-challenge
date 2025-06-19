//
//  Album.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import Foundation

struct AlbumResponse: Decodable {
    let results: [AlbumSong]
}

struct AlbumSong: Identifiable, Decodable {
    var id: Int { trackId ?? 0 }
    let wrapperType: String?
    let collectionName: String?
    let trackName: String?
    let artistName: String
    let trackId: Int?
}
