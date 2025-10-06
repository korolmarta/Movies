import Foundation

struct MovieDetails {
    let title: String
    let country: String?
    let year: String
    let genres: String
    let rating: String
    let overview: String
    let posterURL: URL?
    let trailerURL: String?
}

struct MovieDetailsResponse: Decodable {
    let id: Int
    let title: String
    let overview: String
    let release_date: String
    let vote_average: Double
    let poster_path: String?
    let genres: [Genre]
    let production_countries: [Country]
    
    struct Country: Decodable {
        let name: String
    }
}
