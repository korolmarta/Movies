import Foundation

enum APIConstants {
    static let baseURL = "https://api.themoviedb.org/3"

    static var apiKey: String {
        guard let key = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
            fatalError("‼️ TMDB_API_KEY is missing in Info.plist")
        }
        return key
    }
}
