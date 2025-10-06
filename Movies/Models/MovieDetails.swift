import Foundation

struct MovieDetails {
    let title: String
    let meta: String?
    let genres: String
    let rating: String
    let overview: String
    let posterURL: URL?
    let trailerURL: URL?
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

struct VideosResponse: Decodable {
    let results: [Video]
    struct Video: Decodable {
        let key: String
        let site: String
        let type: String
    }
}
