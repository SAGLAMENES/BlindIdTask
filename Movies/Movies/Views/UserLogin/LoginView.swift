//
//  LoginView.swift
//  Movies
//
//  Created by Enes Saglam on 21.05.2025.
//

import Foundation
import SwiftUI

// MARK: - View
struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isAuthenticated = false


    var body: some View {
        NavigationStack {
            
            ZStack {
                // Animated background
                LinearGradient(gradient: Gradient(colors: [viewModel.gradients[viewModel.gradientIndex].0,
                                                           viewModel.gradients[viewModel.gradientIndex].1]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 2.0), value: viewModel.gradientIndex)
                
                ScrollView {
                    VStack(spacing: 100) {
                        VStack(spacing: 10) {
                            Image(systemName: "film")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            
                            Text(viewModel.isRegistering ? "Create Account" : "Welcome Back")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                        }
                        .padding(.top, 50)
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            if viewModel.isRegistering {
                                CustomTextField(text: $viewModel.name,
                                                placeholder: "First Name",
                                                systemImage: "person")
                                
                                CustomTextField(text: $viewModel.surname,
                                                placeholder: "Last Name",
                                                systemImage: "person")
                            }

                            CustomTextField(text: $viewModel.email,
                                            placeholder: "Email",
                                            systemImage: "envelope")
                            .keyboardType(.emailAddress)
                            
                            CustomSecureField(text: $viewModel.password,
                                              placeholder: "Password",
                                              systemImage: "lock")

                            if viewModel.isRegistering {
                                CustomSecureField(text: $viewModel.confirmPassword,
                                                  placeholder: "Confirm Password",
                                                  systemImage: "lock")
                            }

                            // Submit Button
                            Button(action: {
                                if viewModel.isRegistering {
                                    viewModel.register()
                                } else {
                                    viewModel.login()
                                }
                            }) {
                                Text(viewModel.isRegistering ? "Register" : "Login")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(viewModel.buttonGradient)
                                    .cornerRadius(25)
                                    .shadow(radius: 5)
                            }
                            .padding(.horizontal)

                            // Toggle Button
                            Button(action: {
                                viewModel.toggleRegistrationMode()
                            }) {
                                Text(viewModel.isRegistering ? "Already have an account? Login" : "Don't have an account? Register")
                                    .foregroundColor(.white)
                                    .underline()
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal)

                        
                    }
                    .padding()
                }
            }
            .onAppear {
                viewModel.onSuccess = { _ in
                    isAuthenticated = true
                }
            }
            .navigationDestination(isPresented: $isAuthenticated) {
                MainTabView() // geçici ana ekran
            }
            .alert(isPresented: .constant(!viewModel.errorMessage.isEmpty)) {
                Alert(title: Text(viewModel.isRegistering ? "Registration Failed" : "Login Failed"),
                      message: Text(viewModel.errorMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}


#Preview {
    LoginView()
}
