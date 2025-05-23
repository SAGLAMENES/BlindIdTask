//
//  FavouritesView.swift
//  Movies
//
//  Created by Enes Saglam on 22.05.2025.
//


import Foundation
import MovieAPI
import SwiftUI


@MainActor
final class FavouritesViewModel: ObservableObject {
    // MARK: - Published
    @Published var favouriteMovies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var likedMovieIDs: Set<Int> = []

    // MARK: - Dependencies
    private let service: NetworkServicing

    // MARK: - Init
    init(service: NetworkServicing = NetworkService()) {
        self.service = service
        Task { await loadFavourites() }
    }

    // MARK: - Load
    func loadFavourites() async {
        isLoading = true
        errorMessage = nil
        do {
            let movies = try await service.fetchLikedMovies()
            self.favouriteMovies = movies
            self.likedMovieIDs = Set(movies.map { $0.id })
        } catch {
            errorMessage = "Failed to load favourites: \(error.localizedDescription)"
            favouriteMovies = []
        }
        isLoading = false
    }

    // MARK: - Toggle
    func toggleFavourite(movieID: Int) async {
        do {
            if likedMovieIDs.contains(movieID) {
                try await service.unlikeMovie(id: movieID)
            } else {
                try await service.likeMovie(id: movieID)
            }
            await loadFavourites()
        } catch {
            errorMessage = "Failed to update favourite: \(error.localizedDescription)"
        }
    }

    // MARK: - Helpers
    func isFavourite(_ movieID: Int) -> Bool {
        likedMovieIDs.contains(movieID)
    }
}
