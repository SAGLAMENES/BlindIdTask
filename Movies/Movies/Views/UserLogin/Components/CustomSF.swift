//
//  CustomSF.swift
//  Movies
//
//  Created by Enes Saglam on 21.05.2025.
//

import Foundation
import SwiftUI
struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.gray)
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(25)
        .shadow(radius: 2)
    }
}
