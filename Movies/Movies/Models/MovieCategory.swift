import Foundation

enum MovieCategory: String, CaseIterable {
    case all = "All"
    case action = "Action"
    case comedy = "Comedy"
    case drama = "Drama"
    case horror = "Horror"
    case romance = "Romance"
    case sciFi = "Sci-Fi"
    case thriller = "Thriller"
    case animation = "Animation"
    case documentary = "Documentary"
    
    var icon: String {
        switch self {
        case .all:
            return "film"
        case .action:
            return "bolt.fill"
        case .comedy:
            return "face.smiling"
        case .drama:
            return "theatermasks.fill"
        case .horror:
            return "moon.stars.fill"
        case .romance:
            return "heart.fill"
        case .sciFi:
            return "atom"
        case .thriller:
            return "eye.fill"
        case .animation:
            return "sparkles"
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
        case .comedy:
            return "yellow"
        case .drama:
            return "purple"
        case .horror:
            return "black"
        case .romance:
            return "pink"
        case .sciFi:
            return "blue"
        case .thriller:
            return "orange"
        case .animation:
            return "green"
        case .documentary:
            return "brown"
        }
    }
} 