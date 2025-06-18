//
//  Int+Utils.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import Foundation

extension Int {
    func convertToTime() -> String {
        let minutes = self / 60000
        let seconds = (self % 60000) / 1000
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
