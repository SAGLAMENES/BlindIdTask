//
//  ProfileInfoCard.swift
//  Movies
//
//  Created by Enes Saglam on 23.05.2025.
//

import SwiftUI

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
