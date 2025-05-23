import Foundation

enum MovieCategory: String, CaseIterable {
    case all = "All"
    case action = "Action"
    case adventure = "Adventure"
    case biography = "Biography"
    case comedy = "Comedy"
    case crime = "Crime"
    case drama = "Drama"
    case fantasy = "Fantasy"
    case horror = "Horror"
    case mystery = "Mystery"
    case romance = "Romance"
    case sciFi = "Science Fiction"
    case superhero = "Superhero"
    case thriller = "Thriller"
    case western = "Western"
    case documentary = "Documentary"
    
    var icon: String {
        switch self {
        case .all:
            return "film"
        case .action:
            return "bolt.fill"
        case .adventure:
            return "mountain.2.fill"
        case .biography:
            return "person.fill"
        case .comedy:
            return "face.smiling"
        case .crime:
            return "exclamationmark.triangle.fill"
        case .drama:
            return "theatermasks.fill"
        case .fantasy:
            return "sparkles"
        case .horror:
            return "moon.stars.fill"
        case .mystery:
            return "magnifyingglass"
        case .romance:
            return "heart.fill"
        case .sciFi:
            return "atom"
        case .superhero:
            return "cape.fill"
        case .thriller:
            return "eye.fill"
        case .western:
            return "figure.riding"
        case .documentary:
            return "camera.fill"
        }
    }
    
    var color: String {
        switch self {
        case .all:
            return "gray"
        case .action:
            return "red"
        case .adventure:
            return "green"
        case .biography:
            return "blue"
        case .comedy:
            return "yellow"
        case .crime:
            return "black"
        case .drama:
            return "purple"
        case .fantasy:
            return "indigo"
        case .horror:
            return "black"
        case .mystery:
            return "gray"
        case .romance:
            return "pink"
        case .sciFi:
            return "blue"
        case .superhero:
            return "cyan"
        case .thriller:
            return "orange"
        case .western:
            return "brown"
        case .documentary:
            return "brown"
        }
    }
} 
