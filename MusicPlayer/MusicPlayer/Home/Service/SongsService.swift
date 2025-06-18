//
//  SongsService.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import Foundation
import Combine

protocol SongsServiceProtocol {
    func fetchSongs(query: String, limit: Int) -> AnyPublisher<SongsResponse, Error>
}

final class SongsService: SongsServiceProtocol {
    func fetchSongs(query: String, limit: Int) -> AnyPublisher<SongsResponse, Error> {
        var components = URLComponents(string: "https://itunes.apple.com/search")!
        components.queryItems = [
            URLQueryItem(name: "term", value: query.isEmpty ? "music" : query),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: String(limit)),
        ]
        let url = components.url!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\ .data)
            .decode(type: SongsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
