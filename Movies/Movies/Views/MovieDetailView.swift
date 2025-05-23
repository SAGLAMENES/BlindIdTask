import SwiftUI
import MovieAPI

struct MovieDetailView: View {
    @StateObject var viewModel: MovieDetailViewModel
    let movieID: Int
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(#colorLiteral(red: 0.09, green: 0.07, blue: 0.07, alpha: 1))
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    if let movie = viewModel.movie {
                        // Header with background
                        ZStack(alignment: .bottomLeading) {
                            AsyncImage(url: URL(string: movie.posterURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(height: 500)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(#colorLiteral(red: 0.09, green: 0.07, blue: 0.07, alpha: 1)), .clear]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                        }
                        
                        // Poster and title section
                        HStack(alignment: .bottom, spacing: 16) {
                            AsyncImage(url: URL(string: movie.posterURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 100, height: 150)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(movie.title)
                                    .font(.system(size: 19, weight: .bold))
                                    .foregroundColor(.white)
                                    .truncationMode(.tail)
                                
                                HStack(spacing: 8) {
                                    Text("\(movie.year)")
                                    Text(movie.category)
                                }
                                .font(.caption)
                                .foregroundColor(.gray)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("\(movie.rating, specifier: "%.1f")/10")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    Task {
                                        print("Button tapped")
                                        if viewModel.isFavorite {
                                            await viewModel.dislikeMovie()
                                        } else {
                                            await viewModel.likeMovie()
                                        }
                                    }
                                }) {
                                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                        .font(.title2)
                                        .foregroundColor(viewModel.isFavorite ? .red : .white)
                                        .padding(12)
                                        .shadow(radius: 4)
                                }

                            }
                        }
                        .padding(.horizontal)
                        .padding(.top,-150)
                        // Description
                        Text(movie.description)
                            .foregroundColor(.gray)
                            .font(.body)
                            .padding(.horizontal)
                        
                        // Cast
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cast")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(movie.actors, id: \ .self) { actor in
                                        Text(actor)
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .lineLimit(0)
                                            .padding()
                                            .background {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.gray.opacity(0.3))
                                            }
                                        
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer(minLength: 80)
                    } else if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.top, -80) // Removes top space under status bar
            }
            .onAppear {
                Task {
                    await viewModel.fetchMovie(by: movieID)
                }
            }
            
            // Custom Back Button inside image, fixed position
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(.top, -15)
            .padding(.leading, 20)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
