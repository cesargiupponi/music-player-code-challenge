//
//  Song.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

struct Song: Identifiable, Decodable {
    var id: Int { trackId }
    let trackId: Int
    let collectionId: Int
    let artistName: String
    let trackName: String
    let trackTimeMillis: Int?
}

struct SongsResponse: Decodable {
    let resultCount: Int
    let results: [Song]
}
