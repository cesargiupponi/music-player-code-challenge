//
//  AlbumSong+Mock.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 19/06/25.
//

@testable import MusicPlayer

extension AlbumSong {
    static let mock = AlbumSong(
        wrapperType: "track",
        collectionName: "Test Album",
        trackName: "Test Song",
        artistName: "Test Artist",
        trackId: 180000
    )
    
    static let mockAlbum = AlbumSong(
        wrapperType: "collection",
        collectionName: "Test Album",
        trackName: nil,
        artistName: "Test Artist",
        trackId: nil
    )
}