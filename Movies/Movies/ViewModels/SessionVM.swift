//
//  SessionVm.swift
//  Movies
//
//  Created by Enes Saglam on 23.05.2025.
//

import Foundation
import MovieAPI

@MainActor
final class SessionViewModel: ObservableObject {
  @Published private(set) var isAuthenticated: Bool = false

  private let sessionService: SessionServicing

  init(sessionService: SessionServicing = SessionService()) {
    self.sessionService = sessionService
    self.isAuthenticated = sessionService.isLoggedIn()
  }

  func didLogin(token: String) {
    sessionService.saveToken(token)
    isAuthenticated = true
  }

  func logout() {
    sessionService.clearToken()
          self.isAuthenticated = false
        }
}
