//
//  MoviesApp.swift
//  Movies
//
//  Created by Enes Saglam on 20.05.2025.
//

import SwiftUI
import MovieAPI
@main
struct MoviesApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black // ✅ NavigationBar siyah olur
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
