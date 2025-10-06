import Foundation
import Alamofire

protocol MoviesFetchingServiceProtocol {
    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetailsResponse, Error>) -> Void)
    func fetchMovies(page: Int, sortBy: MoviesSortOption, completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func searchMovies(query: String, page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func fetchGenres(completion: @escaping (Result<[Int: String], Error>) -> Void)
}

final class MoviesFetchingService: MoviesFetchingServiceProtocol {
    private let apiKey = APIConstants.apiKey

    func fetchGenres(completion: @escaping (Result<[Int: String], Error>) -> Void) {
        let genresURL = APIConstants.genresURL
        let parameters: Parameters = [
            "api_key": apiKey,
            "language": "en-US"
        ]
        
        AF.request(genresURL,parameters: parameters)
            .validate()
            .responseDecodable(of: GenreListResponse.self) { response in
            switch response.result {
            case .success(let data):
                let genresMap = Dictionary(uniqueKeysWithValues: data.genres.map { ($0.id, $0.name) })
                completion(.success(genresMap))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovies(
        page: Int,
        sortBy: MoviesSortOption,
        completion: @escaping (Result<MovieResponse, Error>) -> Void
    ) {
        let discoveryURL = APIConstants.discoveryURL
        let parameters: Parameters = [
            "api_key": apiKey,
            "language": "en-US",
            "page": page,
            "sort_by": sortBy.rawValue,
            "include_adult": false
        ]
        
        AF.request(discoveryURL, parameters: parameters)
            .validate()
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    print(movieResponse)
                    completion(.success(movieResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func searchMovies(
        query: String,
        page: Int,
        completion: @escaping (Result<MovieResponse, Error>) -> Void
    ) {
        let searchURL = APIConstants.searchURL
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "language": "en-US",
            "query": query,
            "page": page,
            "include_adult": false
        ]
        
        AF.request(searchURL, parameters: parameters)
            .validate()
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetailsResponse, Error>) -> Void) {
        let movieURL = APIConstants.movieURL + String(id)
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "language": "en-US"
        ]
        
        AF.request(movieURL, parameters: parameters)
            .validate()
            .responseDecodable(of: MovieDetailsResponse.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    completion(.success(movieResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
