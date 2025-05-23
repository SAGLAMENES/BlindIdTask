//
//  EditField.swift
//  Movies
//
//  Created by Enes Saglam on 23.05.2025.
//

import SwiftUI

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
