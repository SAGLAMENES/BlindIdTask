//
//  ContentView.swift
//  Movies
//
//  Created by Enes Saglam on 20.05.2025.
//



import SwiftUI
import MovieAPI

// MARK: - View
struct ContentView: View {
    @StateObject var viewModel: MovieViewModel
    @State private var showSearchBar = false
    @State private var scrollOffset: CGFloat = 0
    @State private var selectedMovieID: Int? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor(#colorLiteral(red: 0.09, green: 0.07, blue: 0.07, alpha: 1)))
                .ignoresSafeArea()
                
                if viewModel.isLoading {
                    LoadingView()
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage) {
                        Task {
                            await viewModel.fetchMovies()
                        }
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            SearchAndFilterView(
                                searchText: $viewModel.searchText,
                                selectedCategory: $viewModel.selectedCategory,
                                showSearchBar: $showSearchBar
                            )
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 16) {
                                ForEach(viewModel.filteredMovies) { movie in
                                    MovieCardView(movie: movie)
                                        .onTapGesture {
                                            selectedMovieID = movie.id
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top)
                    }
                    .refreshable {
                        await viewModel.fetchMovies()
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
        }
        .task {
            await viewModel.fetchMovies()
        }
    }
}

// MARK: - Supporting Views
struct MovieCardView: View {
    let movie: Movie
    @State private var isHovered = false
    
    let gradientColors: [Color] = [Color(UIColor(#colorLiteral(red: 0.1658792049, green: 0.07, blue: 0.07, alpha: 1)))
]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 250)
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .clipped()
                
                AsyncImage(url: URL(string: movie.posterURL)) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.black.opacity(0.2)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }

                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.3), value: UUID()) // her görsel için geçerli

                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.2)
                            Image(systemName: "photo.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.6))
                        }

                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)

                
                // Rating Badge
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", movie.rating))
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .padding(8)
            }
            .frame(height: 250)
            .frame(maxWidth: .infinity)
            
            // Movie Title
            Text(movie.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.clear)
                .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        .frame(width: 180, height: 310) // Fixed card size for consistency
        .background(Color(UIColor(#colorLiteral(red: 0.1658792049, green: 0.07, blue: 0.07, alpha: 1)))
)
        .cornerRadius(12)
        .shadow(radius: isHovered ? 10 : 5)
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

struct SearchAndFilterView: View {
    @Binding var searchText: String
    @Binding var selectedCategory: MovieCategory
    @Binding var showSearchBar: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Modern Search Bar
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search movies...", text: $searchText)
                        .foregroundColor(.primary)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.08), radius: 4, y: 2)
                .animation(.easeInOut, value: searchText)
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    withAnimation(.spring()) {
                        showSearchBar.toggle()
                        if !showSearchBar { searchText = "" }
                    }
                }) {
                    Image(systemName: showSearchBar ? "chevron.up" : "magnifyingglass")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.purple.opacity(0.7))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
            }
            .padding(.horizontal)
            .opacity(showSearchBar ? 1 : 0)
            .frame(height: showSearchBar ? nil : 0)
            .animation(.easeInOut, value: showSearchBar)
            
            // Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(MovieCategory.allCases, id: \ .self) { category in
                        CategoryChip(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            withAnimation {
                                selectedCategory = category
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 8)
    }
}

struct CategoryChip: View {
    let category: MovieCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 13))
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .regular)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background {
                if isSelected {
                    Color.white.opacity(0.7)
                } else {
                    Color.gray.opacity(0.18)
                }
            }
            .foregroundColor(.white)
            .cornerRadius(18)
            .shadow(color: isSelected ? Color.purple.opacity(0.18) : .clear, radius: 6, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.white.opacity(0.7) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading movies...")
                .foregroundColor(.white)
        }
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text(message)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// Helper extension for custom corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: MovieViewModel(service: MockMovieService()))
    }
}
