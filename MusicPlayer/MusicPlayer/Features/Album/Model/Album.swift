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
    let collectionId: Int?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let previewUrl: String?
    let trackViewUrl: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let primaryGenreName: String?
    let trackTimeMillis: Int?
}
