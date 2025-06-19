//
//  MusicPlayerViewState.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

enum MusicPlayerViewState {
    case idle
    case loading
    case loaded
    case error(Error)
    case empty
}