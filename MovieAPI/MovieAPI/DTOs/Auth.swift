//
//  Auth.swift
//  Movies
//
//  Created by Enes Saglam on 21.05.2025.
//

public struct LoginRequest: Codable {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct LoginResponse: Codable {
    public let message: String
    public let token: String
    public let user: User
}

public struct RegisterRequest: Codable {
    public let name: String
    public let surname: String
    public let email: String
    public let password: String
}
