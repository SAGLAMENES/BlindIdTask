//
//  MainTabView.swift
//  Movies
//
//  Created by Enes Saglam on 22.05.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    ContentView(viewModel: MovieViewModel())
                        .ignoresSafeArea(edges: .bottom)
                case 1:
                    FavouritesView()
                case 2:
                    ProfileView()
                default:
                    ContentView(viewModel: MovieViewModel())
                }
            }
            
            HStack {
                TabBarButton(icon: "film", label: "Movies", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                Spacer()
                TabBarButton(icon: "heart.fill", label: "Favourites", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                Spacer()
                TabBarButton(icon: "person.circle", label: "Profile", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .padding(.horizontal, 29)
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .shadow(color: Color.purple.opacity(0.18), radius: 16, y: 4)
            .padding(.horizontal, 29)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    MainTabView()
}
