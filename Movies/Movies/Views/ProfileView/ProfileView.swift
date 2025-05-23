//
//  ProfileView.swift
//  Movies
//
//  Created by Enes Saglam on 22.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var sessionVM: SessionViewModel

    @State private var showEditField: EditFieldType?
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastColor: Color = .green
    @State private var showLogoutConfirmation = false

    enum EditFieldType: Identifiable {
        case name, surname, email
        var id: Int {
            switch self {
            case .name: return 1
            case .surname: return 2
            case .email: return 3
            }
        }
    }

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.09, green: 0.07, blue: 0.07, alpha: 1)), Color.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: Color.purple.opacity(0.3), radius: 20, x: 0, y: 10)
                            Text(initials)
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.white)
                        }
                        VStack(spacing: 4) {
                            Text("\(viewModel.name) \(viewModel.surname)")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            Text(viewModel.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 40)

                    // Profile Information Cards
                    VStack(spacing: 16) {
                        ProfileInfoCard(
                            title: "Name",
                            value: viewModel.name.isEmpty ? "Not set" : viewModel.name,
                            icon: "person.fill",
                            onEdit: { showEditField = .name }
                        )
                        ProfileInfoCard(
                            title: "Surname",
                            value: viewModel.surname.isEmpty ? "Not set" : viewModel.surname,
                            icon: "person.fill",
                            onEdit: { showEditField = .surname }
                        )
                        ProfileInfoCard(
                            title: "Email",
                            value: viewModel.email.isEmpty ? "Not set" : viewModel.email,
                            icon: "envelope.fill",
                            onEdit: { showEditField = .email }
                        )
                        Button("Logout") {
                            showLogoutConfirmation = true
                        }
                        .foregroundColor(.red)
                    }
                    .padding(.horizontal, 20)
                    Spacer(minLength: 100)
                }
            }

            // Toast Feedback
            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Text(toastMessage)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(toastColor.opacity(0.9))
                            .cornerRadius(16)
                            .shadow(radius: 8)
                    }
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }

            // Loading Overlay
            if viewModel.isLoading {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .task { await viewModel.loadProfile() }
        .sheet(item: $showEditField) { field in
            switch field {
            case .name:
                EditFieldSheet(
                    title: "Edit Name",
                    value: $viewModel.name,
                    placeholder: "Enter your name",
                    icon: "person.fill"
                ) {
                    Task {
                        await viewModel.updateProfile()
                        showFeedback()
                    }
                }
            case .surname:
                EditFieldSheet(
                    title: "Edit Surname",
                    value: $viewModel.surname,
                    placeholder: "Enter your surname",
                    icon: "person.fill"
                ) {
                    Task {
                        await viewModel.updateProfile()
                        showFeedback()
                    }
                }
            case .email:
                EditFieldSheet(
                    title: "Edit Email",
                    value: $viewModel.email,
                    placeholder: "Enter your email",
                    icon: "envelope.fill",
                    keyboardType: .emailAddress
                ) {
                    Task {
                        await viewModel.updateProfile()
                        showFeedback()
                    }
                }
            }
        }
        .onChange(of: viewModel.errorMessage) {
            guard let error = viewModel.errorMessage, !error.isEmpty else { return }
            toastMessage = error
            toastColor = .red
            showToastWithDelay()
            // Hatalı mesajı sıfırla
            viewModel.errorMessage = nil
        }
        .onChange(of: viewModel.successMessage) {
            guard let success = viewModel.successMessage, !success.isEmpty else { return }
            toastMessage = success
            toastColor = .green
            showToastWithDelay()
            viewModel.successMessage = nil
        }
        .alert(isPresented: $showLogoutConfirmation) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to logout?"),
                primaryButton: .destructive(Text("Logout")) {
                    sessionVM.logout()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private var initials: String {
        let nameInitial = viewModel.name.first.map { String($0) } ?? "U"
        let surnameInitial = viewModel.surname.first.map { String($0) } ?? "S"
        return nameInitial + surnameInitial
    }

    private func formatCreatedDate() -> String {
        // TODO: createdDate'ı ViewModel'dan çek!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return viewModel.createdDate.map { formatter.string(from: $0) } ?? "-"
    }

    private func showFeedback() {
        // Başarılı ya da hatalı mesajı göster
        if let error = viewModel.errorMessage, !error.isEmpty {
            toastMessage = error
            toastColor = .red
            showToastWithDelay()
            viewModel.errorMessage = nil
        } else if let success = viewModel.successMessage, !success.isEmpty {
            toastMessage = success
            toastColor = .green
            showToastWithDelay()
            viewModel.successMessage = nil
        }
    }

    private func showToastWithDelay() {
        withAnimation { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut) { showToast = false }
        }
    }
}




#Preview {
    ProfileView()
}
