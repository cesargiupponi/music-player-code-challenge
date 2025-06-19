//
//  MoreOptionsViewModel.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import Foundation
import SwiftUI

@MainActor
class MoreOptionsViewModel: ObservableObject {

    @Published var song: SongBottomSheet

    init(song: SongBottomSheet) {
        self.song = song
    }    
}
