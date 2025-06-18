import Foundation
import SwiftUI

@MainActor
class MoreOptionsViewModel: ObservableObject {

    @Published var song: SongBottomSheet

    init(song: SongBottomSheet) {
        self.song = song
    }    
}
