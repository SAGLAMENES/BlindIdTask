//
//  TabBarButton.swift
//  Movies
//
//  Created by Enes Saglam on 22.05.2025.
//

import SwiftUI
struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: isSelected ? 28 : 22, weight: .bold))
                    .foregroundColor(isSelected ? Color(UIColor(#colorLiteral(red: 0.1658792049, green: 0.07, blue: 0.07, alpha: 1))) : .black.opacity(0.3))
                Text(label)
                    .font(.caption.bold())
                    .foregroundColor(isSelected ? Color(UIColor(#colorLiteral(red: 0.1658792049, green: 0.07, blue: 0.07, alpha: 1))) : .black.opacity(0.7))
            }
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity)
        }
    }
}

