import Foundation

struct GenreListResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}
