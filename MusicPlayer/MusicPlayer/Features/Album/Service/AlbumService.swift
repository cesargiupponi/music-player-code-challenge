//
//  AlbumService.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import Foundation

protocol AlbumServiceProtocol: Sendable {
    func fetchAlbumSongs(collectionId: Int) async throws -> AlbumResponse
}

final class AlbumService: AlbumServiceProtocol {
    func fetchAlbumSongs(collectionId: Int) async throws -> AlbumResponse {
        let url = URL(string: "https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(AlbumResponse.self, from: data)
    }
} 
