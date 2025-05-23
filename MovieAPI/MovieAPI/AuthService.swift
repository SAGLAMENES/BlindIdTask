//
//  AuthService.swift
//  MovieAPI
//
//  Created by Enes Saglam on 21.05.2025.
//

import Foundation

public protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func register(name: String, surname: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
}

public final class AuthService: AuthServiceProtocol {
    private let baseURL = "https://moviatask.cerasus.app/api/auth"

    public init() {}

    public func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let requestBody = LoginRequest(email: email, password: password)
        guard let url = URL(string: "\(baseURL)/login") else {
            completion(.failure(AuthError.invalidURL))
            return
        }

        makePOSTRequest(to: url, with: requestBody, completion: completion)
    }

    public func register(name: String, surname: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let requestBody = RegisterRequest(name: name, surname: surname, email: email, password: password)
        guard let url = URL(string: "\(baseURL)/register") else {
            completion(.failure(AuthError.invalidURL))
            return
        }

        makePOSTRequest(to: url, with: requestBody, completion: completion)
    }

    // MARK: - Private

    private func makePOSTRequest<T: Codable>(to url: URL, with body: T, completion: @escaping (Result<User, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(AuthError.noData))
                    return
                }

                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    KeychainService.save(key: "authToken", value: response.token) // ✅ Token artık Keychain'de
                    completion(.success(response.user))
                } catch {
                    completion(.failure(AuthError.decoding(error)))
                }
            }
        }.resume()
    }
}
