//
//  MovieVM.swift
//  Movies
//
//  Created by Enes Saglam on 20.05.2025.
//

import Foundation
import MovieAPI

@MainActor
final class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedMovie: Movie?
    @Published var searchText = ""
    @Published var selectedCategory: MovieCategory = .all
    private let service: NetworkServicing

    init(service: NetworkServicing = NetworkService()) {
        self.service = service
    }
    
    var filteredMovies: [Movie] {
        var filtered = movies
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        if selectedCategory != .all {
            filtered = filtered.filter { movie in
                // Convert the movie's category string to MovieCategory
                if let movieCategory = MovieCategory(rawValue: movie.category) {
                    return movieCategory == selectedCategory
                }
                return false
            }
        }
        
        return filtered
    }
    
    func fetchMovies() async {
        isLoading = true
        do {
            let result = try await service.fetchMovies()
            self.movies = result
        } catch {
            if let decodingError = error as? DecodingError {
                print("❌ Decoding error: \(decodingError)")
            } else {
                print("❌ Error: \(error.localizedDescription)")
            }
            self.errorMessage = "Veri okunamadı: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
