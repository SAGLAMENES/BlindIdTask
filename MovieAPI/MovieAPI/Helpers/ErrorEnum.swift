//
//  ErrorEnum.swift
//  MovieAPI
//
//  Created by Enes Saglam on 21.05.2025.
//

import Foundation

public enum AuthError: Error, LocalizedError {
    case invalidURL
    case noData
    case decoding(Error)
    case api(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        case .decoding(let err): return "Failed to decode response: \(err.localizedDescription)"
        case .api(let msg): return msg
        }
    }
}

