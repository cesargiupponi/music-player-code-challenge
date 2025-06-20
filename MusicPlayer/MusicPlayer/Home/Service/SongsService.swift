//
//  SongsService.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 17/06/25.
//

import Foundation

protocol SongsServiceProtocol: Sendable {
    func fetchSongs(query: String, limit: Int) async throws -> SongsResponse
}

final class SongsService: SongsServiceProtocol {
    func fetchSongs(query: String, limit: Int) async throws -> SongsResponse {
        var components = URLComponents(string: "https://itunes.apple.com/search")!
        components.queryItems = [
            URLQueryItem(name: "term", value: query.isEmpty ? "music" : query),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: String(limit)),
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(SongsResponse.self, from: data)
    }
}
