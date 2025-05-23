//
//  MovieDetailVM.swift
//  Movies
//
//  Created by Enes Saglam on 22.05.2025.
//

import MovieAPI
import SwiftUI
import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite = false
    
    public let service: NetworkServicing
    
    init(service: NetworkServicing = NetworkService()) {
        self.service = service
    }
    
    func likeMovie() async {
          guard let id = movie?.id else { return }
          do {
              try await service.likeMovie(id: id)
              isFavorite = true
          } catch {
              errorMessage = "Failed to like movie: \(error.localizedDescription)"
          }
      }
    func dislikeMovie() async {
        guard let id = movie?.id else { return }
        do {
            try await service.unlikeMovie(id: id)
            isFavorite = false
        } catch {
            errorMessage = "Failed to unlike movie: \(error.localizedDescription)"
        }
    }
    
    func checkIfFavorite(id: Int) async throws -> Bool {
        let ids = try await service.fetchLikedMovieIDs()
        return ids.contains(id)
    }
    
    func fetchMovie(by id: Int) async {
        isLoading = true
        errorMessage = nil
        // 1. Fetch movie details
        do {
            let result = try await service.fetchMovie(by: id)
            self.movie = result
        } catch {
            self.errorMessage = "Failed to load movie details: \(error.localizedDescription)"
            isLoading = false
            return
        }
        // 2. Fetch favorite status
        do {
            let favorites = try await service.fetchLikedMovieIDs()
            self.isFavorite = favorites.contains(id)
        } catch {
            // Non-fatal: movie details shown even if favorite check fails
            self.errorMessage = "Could not determine favorite status: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
