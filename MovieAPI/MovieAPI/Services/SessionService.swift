//
//  SessionService.swift
//  MovieAPI
//
//  Created by Enes Saglam on 23.05.2025.
//

import Foundation

public protocol SessionServicing {
  func currentToken() -> String?
  func saveToken(_ token: String)
  func clearToken()
  func isLoggedIn() -> Bool
}

public final class SessionService: SessionServicing {
  private let key = "authToken"

  public init() {}

  public func currentToken() -> String? {
    KeychainService.read(key: key)
  }

  public func saveToken(_ token: String) {
    KeychainService.save(key: key, value: token)
  }

  public func clearToken() {
    KeychainService.delete(key: key)
  }

  public func isLoggedIn() -> Bool {
    currentToken() != nil
  }
}
