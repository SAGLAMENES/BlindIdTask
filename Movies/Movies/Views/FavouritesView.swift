//
//  FavouritesView.swift
//  Movies
//
//  Created by Enes Saglam on 22.05.2025.
//

import SwiftUI

struct FavouritesView: View {
    @StateObject private var viewModel = FavouritesViewModel()
    @State private var selectedMovieID: Int? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color(#colorLiteral(red: 0.09, green: 0.07, blue: 0.07, alpha: 1))
                    .ignoresSafeArea()

                if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        Task { await viewModel.loadFavourites() }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)],
                            spacing: 16
                        ) {
                            ForEach(viewModel.favouriteMovies) { movie in
                                MovieCardView(movie: movie)
                                    .onTapGesture {
                                        selectedMovieID = movie.id
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .refreshable {
                        await viewModel.loadFavourites()
                    }
                }

                NavigationLink(
                    destination: selectedMovieID.map { id in
                        MovieDetailView(viewModel: MovieDetailViewModel(), movieID: id)
                    },
                    isActive: Binding(
                        get: { selectedMovieID != nil },
                        set: { if !$0 { selectedMovieID = nil } }
                    )
                ) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
            .task {
                            await viewModel.loadFavourites()
                        }
        }
    }
}

#Preview {
    FavouritesView()
}
