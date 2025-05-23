//
//  LoginVM.swift
//  Movies
//
//  Created by Enes Saglam on 21.05.2025.
//

import Foundation
import SwiftUI
import MovieAPI

final class LoginViewModel: ObservableObject {
    // MARK: - Input
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // MARK: - UI State
    @Published var isRegistering: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var gradientIndex: Int = 0

    // MARK: - Auth Service
    private let authService: AuthServiceProtocol

    // MARK: - Login/Register Callback
    var onSuccess: ((User) -> Void)?

    // MARK: - Gradients
    let gradients: [(Color, Color)] = [
        (Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.2, green: 0.1, blue: 0.4)),
        (Color(red: 0.2, green: 0.1, blue: 0.4), Color(red: 0.3, green: 0.1, blue: 0.2)),
        (Color(red: 0.3, green: 0.1, blue: 0.2), Color(red: 0.2, green: 0.2, blue: 0.3)),
        (Color(red: 0.2, green: 0.2, blue: 0.3), Color(red: 0.1, green: 0.1, blue: 0.3))
    ]

    let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.purple]),
        startPoint: .leading,
        endPoint: .trailing
    )

    private var gradientTimer: Timer?

    // MARK: - Init
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        startGradientAnimation()
    }

    deinit {
        gradientTimer?.invalidate()
    }

    // MARK: - UI Action
    func toggleRegistrationMode() {
        withAnimation(.spring()) {
            isRegistering.toggle()
            errorMessage = ""
        }
    }

    // MARK: - Login
    func login() {
        guard validateLoginInput() else { return }

        isLoading = true
        errorMessage = ""

        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.onSuccess?(user)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // MARK: - Register
    func register() {
        guard validateRegisterInput() else { return }

        isLoading = true
        errorMessage = ""

        authService.register(name: name, surname: surname, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.onSuccess?(user)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // MARK: - Input Validation
    private func validateLoginInput() -> Bool {
        if email.isEmpty {
            errorMessage = "Please enter your email"
            return false
        }
        if password.isEmpty {
            errorMessage = "Please enter your password"
            return false
        }
        return true
    }

    private func validateRegisterInput() -> Bool {
        if name.isEmpty {
            errorMessage = "Please enter your name"
            return false
        }
        if surname.isEmpty {
            errorMessage = "Please enter your surname"
            return false
        }
        if email.isEmpty {
            errorMessage = "Please enter your email"
            return false
        }
        if password.isEmpty {
            errorMessage = "Please enter your password"
            return false
        }
        if confirmPassword.isEmpty {
            errorMessage = "Please confirm your password"
            return false
        }
        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            return false
        }
        return true
    }

    // MARK: - Background Animation
    private func startGradientAnimation() {
        gradientTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            withAnimation {
                self.gradientIndex = (self.gradientIndex + 1) % self.gradients.count
            }
        }
    }
}
