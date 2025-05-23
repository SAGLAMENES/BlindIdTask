//
//  ProfileService.swift
//  MovieAPI
//
//  Created by Enes Saglam on 22.05.2025.
//
import Foundation

public final class ProfileService {
    private let baseURL = "https://moviatask.cerasus.app/api"
    public init() {}

    public func getProfile() async throws -> ProfileDTO {
        let url = URL(string: "\(baseURL)/auth/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = KeychainService.read(key: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if (200...299).contains(http.statusCode) {
            return try JSONDecoder().decode(ProfileDTO.self, from: data)
        } else {
            let errDict = try? JSONDecoder().decode([String:String].self, from: data)
            let msg = errDict?["error"] ?? errDict?["message"] ?? "Server error"
            throw NSError(domain: "ProfileError",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: msg])
        }
    }

    @discardableResult
    public func updateProfile(name: String, surname: String, email: String) async throws -> UpdatedUserDTO {
        let url = URL(string: "\(baseURL)/users/profile")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainService.read(key: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let body = ["name": name, "surname": surname, "email": email]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if (200...299).contains(http.statusCode) {
            let updateResp = try JSONDecoder().decode(UpdateProfileResponseDTO.self, from: data)
            return updateResp.user
        } else {
            let errDict = try? JSONDecoder().decode([String:String].self, from: data)
            let msg = errDict?["error"] ?? errDict?["message"] ?? "Server error"
            throw NSError(domain: "ProfileError",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: msg])
        }
    }
}
