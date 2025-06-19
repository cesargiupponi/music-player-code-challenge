//
//  MockSongsService.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

@testable import MusicPlayer
import Foundation

actor MockSongsService: SongsServiceProtocol {
    private var mockResponse: SongsResponse?
    private var mockError: Error?
    private var delay: TimeInterval = 0
    var fetchCallCount = 0

    func setMockResponse(_ response: SongsResponse?) {
        mockResponse = response
    }
    
    func setMockError(_ error: Error?) {
        mockError = error
    }
    
    func setDelay(_ delay: TimeInterval) {
        self.delay = delay
    }
    
    func fetchSongs(query: String, limit: Int) async throws -> SongsResponse {

        fetchCallCount += 1

        // Add delay if specified
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        if let error = mockError {
            throw error
        }
        
        if let response = mockResponse {
            return response
        }
        
        // Fallback to real implementation if no mock is set
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

