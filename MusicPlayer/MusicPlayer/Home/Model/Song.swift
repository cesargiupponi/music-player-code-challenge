//
//  Song.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

struct Song: Identifiable, Decodable {
    var id: Int { trackId }
    let trackId: Int
    let artistName: String
    let collectionName: String
    let trackName: String
    let artworkUrl60: String?
    let artworkUrl100: String?
    let previewUrl: String?
    let trackViewUrl: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let primaryGenreName: String?
    let trackTimeMillis: Int?
}