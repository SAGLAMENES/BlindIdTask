//
//  ErrorEnum.swift
//  MovieAPI
//
//  Created by Enes Saglam on 21.05.2025.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidURL
    case noData
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL is invalid"
        case .noData:
            return "No response data received"
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
