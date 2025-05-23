//
//  User.swift
//  MovieAPI
//
//  Created by Enes Saglam on 21.05.2025.
//

import Foundation

// MARK: - User
public struct User: Codable, Identifiable {
    public let id: String
    public let name: String
    public let surname: String
    public let email: String
}

// MARK: - Profile (GET /auth/me) Response DTO
public struct ProfileDTO: Codable {
    public let id: String
    public let name: String
    public let surname: String
    public let email: String
    public let likedMovies: [Int]
    public let createdAt: String
    public let updatedAt: String
    public let version: Int

    enum CodingKeys: String, CodingKey {
        case id         = "_id"
        case name
        case surname
        case email
        case likedMovies
        case createdAt
        case updatedAt
        case version    = "__v"
    }
}

// MARK: - Update Profile (PUT /users/profile) Response DTO
public struct UpdateProfileResponseDTO: Codable {
    public let message: String
    public let user: UpdatedUserDTO

    enum CodingKeys: String, CodingKey {
        case message
        case user
    }
}
// MARK: - Update User

public struct UpdatedUserDTO: Codable {
    public let id: String
    public let name: String
    public let surname: String
    public let email: String

    enum CodingKeys: String, CodingKey {
        case id      = "id"
        case name
        case surname
        case email
    }
}
