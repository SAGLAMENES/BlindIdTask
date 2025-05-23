//
//  RootView.swift
//  Movies
//
//  Created by Enes Saglam on 23.05.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var sessionVM: SessionViewModel

    var body: some View {
        Group {
            if sessionVM.isAuthenticated {
                MainTabView()
            } else {
                LoginView { token in
                    sessionVM.didLogin(token: token)
                }
            }
        }
    }
}




#Preview {
    RootView()
}
