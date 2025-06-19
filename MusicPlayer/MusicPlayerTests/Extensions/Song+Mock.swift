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
}
