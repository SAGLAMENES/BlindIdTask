//
//  Movie.swift
//  MovieAPI
//
//  Created by Enes Saglam on 20.05.2025.
//

import Foundation

public struct Movie: Codable, Identifiable {
    public let id: Int
    public let title: String
    public let year: Int
    public let rating: Double
    public let actors: [String]
    public let category: String
    public let posterURL: String
    public let description: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case rating
        case actors
        case category
        case posterURL = "poster_url"
        case description
    }
}



struct MockMovieData {
    static let sampleMovies: [Movie] = [
        Movie(
            id: 1,
            title: "Inception",
            year: 2010,
            rating: 8.8,
            actors: ["Leonardo DiCaprio", "Joseph Gordon-Levitt", "Elliot Page"],
            category: "Science Fiction",
            posterURL: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_FMjpg_UX1000_.jpg",
            description: "A skilled thief is offered a chance to erase his criminal history by planting an idea into a target's subconscious."
        ),
        Movie(
            id: 2,
            title: "The Godfather",
            year: 1972,
            rating: 9.2,
            actors: ["Marlon Brando", "Al Pacino", "James Caan"],
            category: "Crime",
            posterURL: "https://storage.googleapis.com/pod_public/1300/262788.jpg",
            description: "The aging patriarch of a crime dynasty transfers control of his empire to his reluctant son."
        )
    ]
}
