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
    @State private var showEditName = false
    @State private var showEditSurname = false
    @State private var showEditEmail = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastColor: Color = .green
    
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
                            onEdit: { showEditName = true }
                        )
                        
                        ProfileInfoCard(
                            title: "Surname",
                            value: viewModel.surname.isEmpty ? "Not set" : viewModel.surname,
                            icon: "person.fill",
                            onEdit: { showEditSurname = true }
                        )
                        
                        ProfileInfoCard(
                            title: "Email",
                            value: viewModel.email.isEmpty ? "Not set" : viewModel.email,
                            icon: "envelope.fill",
                            onEdit: { showEditEmail = true }
                        )
                        
                        ProfileInfoCard(
                            title: "Member Since",
                            value: formatCreatedDate(),
                            icon: "calendar",
                            onEdit: nil // Non-editable
                        )
                        Section {
                                Button("Logout") {
                                  sessionVM.logout()
                                }
                                .foregroundColor(.red)
                              }
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
        .sheet(isPresented: $showEditName) {
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
        }
        .sheet(isPresented: $showEditSurname) {
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
        }
        .sheet(isPresented: $showEditEmail) {
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
        .onChange(of: viewModel.errorMessage) { newValue in
            if let error = newValue {
                toastMessage = error
                toastColor = .red
                showToast = true
                hideToastAfterDelay()
            }
        }
        .onChange(of: viewModel.successMessage) { newValue in
            if let success = newValue {
                toastMessage = success
                toastColor = .green
                showToast = true
                hideToastAfterDelay()
            }
        }
    }
    
    private var initials: String {
        let nameInitial = viewModel.name.first.map { String($0) } ?? "U"
        let surnameInitial = viewModel.surname.first.map { String($0) } ?? "S"
        return nameInitial + surnameInitial
    }
    
    private func formatCreatedDate() -> String {
        // You'll need to add a createdDate property to your ProfileViewModel
        // For now, I'll use a placeholder - you can update this when you add the actual date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date()) // Replace with actual created date
    }
    
    private func showFeedback() {
        if let error = viewModel.errorMessage {
            toastMessage = error
            toastColor = .red
            showToast = true
            hideToastAfterDelay()
        } else if let success = viewModel.successMessage {
            toastMessage = success
            toastColor = .green
            showToast = true
            hideToastAfterDelay()
        }
    }
    
    private func hideToastAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut) { showToast = false }
        }
    }
}

// MARK: - Profile Info Card
struct ProfileInfoCard: View {
    let title: String
    let value: String
    let icon: String
    let onEdit: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.purple)
                .frame(width: 24, height: 24)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Edit Button (if editable)
            if let onEdit = onEdit {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.purple)
                        .padding(8)
                        .background(Color.purple.opacity(0.2))
                        .clipShape(Circle())
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Edit Field Sheet
struct EditFieldSheet: View {
    let title: String
    @Binding var value: String
    let placeholder: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    let onSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var editedValue: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                // TextField
                VStack(spacing: 8) {
                    TextField(placeholder, text: $editedValue)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(keyboardType)
                        .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                    
                    Text("Enter your \(title.lowercased())")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        value = editedValue
                        onSave()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(editedValue.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .onAppear {
            editedValue = value
        }
    }
}

#Preview {
    ProfileView()
}
