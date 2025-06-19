//
//  Song+Mock.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

@testable import MusicPlayer

extension Song {
    static let mock = Song(trackId: 1,
                           collectionId: 123,
                           artistName: "Artist",
                           trackName: "Music",
                           trackTimeMillis: 12344)
    static let mock2 = Song(trackId: 2,
                           collectionId: 123,
                           artistName: "Artist 2",
                           trackName: "Music 2",
                           trackTimeMillis: 180000)

    static let mock3 = Song(trackId: 3,
                           collectionId: 123,
                           artistName: "Artist 3",
                           trackName: "Music 3",
                           trackTimeMillis: 200000)
}
