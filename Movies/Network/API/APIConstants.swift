import Foundation

enum APIConstants {
    static private let baseURL = "https://api.themoviedb.org/3"
    static private let genresPath = "/genre/movie/list?"
    static private let discoveryPath = "/discover/movie?"
    static private let searchPath = "/search/movie?"
    static let imageURLBase = "https://image.tmdb.org/t/p/w500"
    
    static let genresURL = baseURL + genresPath
    static let discoveryURL = baseURL + discoveryPath
    static let searchURL = baseURL + searchPath
    
    static var apiKey: String {
        guard let key = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
            fatalError("‼️ TMDB_API_KEY is missing in Info.plist")
        }
        return key
    }
}
