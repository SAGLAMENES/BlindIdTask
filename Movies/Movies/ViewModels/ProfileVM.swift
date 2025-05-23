//
//  ProfileVM.swift
//  Movies
//
//  Created by Enes Saglam on 22.05.2025.
//



import Foundation
import SwiftUI
import MovieAPI

@MainActor
final class ProfileViewModel: ObservableObject {
    // MARK: - Inputs
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var email: String = ""
    @Published var createdDate: Date? = nil

    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    // MARK: - Dependencies
    private let service: ProfileService

    init(service: ProfileService = ProfileService()) {
        self.service = service
    }

    /// Profil bilgilerini yükler
    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        do {
            let user = try await service.getProfile()
            name = user.name
            surname = user.surname
            email = user.email
        } catch {
            errorMessage = "Failed to load profile: \(error.localizedDescription)"
        }
        isLoading = false
    }

    func updateProfile() async {
        guard !name.isEmpty, !surname.isEmpty, !email.isEmpty else {
            errorMessage = "All fields are required"
            return
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        do {
            let updated = try await service.updateProfile(
                name: name,
                surname: surname,
                email: email
            )
            // Sunucudan dönen yeni kullanıcı bilgileri
            name = updated.name
            surname = updated.surname
            email = updated.email

            successMessage = "Profile updated successfully"
        } catch {
            errorMessage = "Update failed: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
