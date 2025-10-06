import Foundation

enum MoviesSortOption: String, CaseIterable {
    case popularityDesc = "popularity.desc"
    case ratingDesc = "vote_average.desc"
    case releaseDateDesc = "primary_release_date.desc"
    
    var title: String {
        switch self {
        case .popularityDesc:
            return "Popularity"
        case .ratingDesc:
            return "Rating"
        case .releaseDateDesc:
            return "Release Date"
        }
    }
}
