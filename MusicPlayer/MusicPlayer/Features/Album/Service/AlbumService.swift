//
//  AlbumService.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import Foundation
import Combine

protocol AlbumServiceProtocol {
    func fetchAlbumSongs(collectionId: Int) -> AnyPublisher<AlbumResponse, Error>
}

final class AlbumService: AlbumServiceProtocol {

    func fetchAlbumSongs(collectionId: Int) -> AnyPublisher<AlbumResponse, Error> {

        let url = URL(string: "https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\ .data)
            .decode(type: AlbumResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
} 
