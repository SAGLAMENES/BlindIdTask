//
//  MovieAPI.swift
//  MovieAPI
//
//  Created by Enes Saglam on 20.05.2025.
//

import Foundation

import Foundation

public protocol NetworkServicing {
    func fetchMovies() async throws -> [Movie]
    func fetchMovie(by id: Int) async throws -> Movie
    func fetchLikedMovieIDs() async throws -> [Int]
    func fetchLikedMovies() async throws -> [Movie]
    func likeMovie(id: Int) async throws
    func unlikeMovie(id: Int) async throws
}

public struct NetworkService: NetworkServicing {
    private let baseURL = "https://moviatask.cerasus.app/api"
    public init() {}

    public func fetchMovies() async throws -> [Movie] {
        try await get("/movies", as: [Movie].self)
    }

    public func fetchMovie(by id: Int) async throws -> Movie {
        try await get("/movies/\(id)", as: Movie.self)
    }

    public func fetchLikedMovieIDs() async throws -> [Int] {
        try await get("/users/liked-movie-ids", as: [Int].self)
    }

    public func fetchLikedMovies() async throws -> [Movie] {
        try await get("/users/liked-movies", as: [Movie].self)
    }

    public func likeMovie(id: Int) async throws {
        _ = try await post("/movies/like/\(id)")
    }

    public func unlikeMovie(id: Int) async throws {
        _ = try await post("/movies/unlike/\(id)")
    }

    private func get<T: Decodable>(_ path: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = KeychainService.read(key: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func post(_ path: String) async throws -> Data {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = KeychainService.read(key: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
/*
public struct MockMovieService: NetworkServicing {
    public init() {}
    public func fetchMovies() async throws -> [Movie] {
        return MockMovieData.sampleMovies
    }
    public func fetchMovie(by id: Int) async throws -> Movie {
        guard let m = MockMovieData.sampleMovies.first(where: { $0.id == id }) else {
            throw URLError(.fileDoesNotExist)
        }
        return m
    }
    public func fetchLikedMovieIDs() async throws -> [Int] {
        // Return IDs for sample favourites
        return [MockMovieData.sampleMovies.first?.id].compactMap { $0 }
    }
    public func fetchLikedMovies() async throws -> [Movie] {
        // Return sample favourites
        return [MockMovieData.sampleMovies.first].compactMap { $0 }
    }
    public func likeMovie(id: Int) async throws {
        // Simulate like
    }
    public func unlikeMovie(id: Int) async throws {
        // Simulate unlike
    }
}
*/
