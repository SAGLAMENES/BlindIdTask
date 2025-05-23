//
//  Error.swift
//  MovieAPI
//
//  Created by Enes Saglam on 23.05.2025.
//

import Foundation
struct APIErrorResponse: Codable {
    let message: String?
    let error: String?
}
