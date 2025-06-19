//
//  MusicPlayerViewState+Equatable.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 19/06/25.
//

@testable import MusicPlayer

extension MusicPlayerViewState: @retroactive Equatable {
    public static func == (lhs: MusicPlayerViewState, rhs: MusicPlayerViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.loaded, .loaded),
             (.empty, .empty):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
