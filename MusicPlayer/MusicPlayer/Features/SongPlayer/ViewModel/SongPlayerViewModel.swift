import Foundation
import Combine

final class SongPlayerViewModel: ObservableObject {

    @Published var song: Song

    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?

    var trackDuration: Int {
        song.trackTimeMillis ?? 0
    }

    init(song: Song) {
        self.song = song
    }
}
