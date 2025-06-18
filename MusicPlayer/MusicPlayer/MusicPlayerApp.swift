//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 16/06/25.
//

import SwiftUI

@main
struct MusicPlayerApp: App {

    let navBarAppearence = UINavigationBarAppearance()

    init() {
        navBarAppearence.configureWithOpaqueBackground()
        navBarAppearence.backgroundColor = .black
        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = navBarAppearence
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearence
        UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [.foregroundColor: UIColor.white]
        UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        UISearchBar.appearance().tintColor = .white
    }

    var body: some Scene {
        WindowGroup {
            SongsView()
        }
    }
}
