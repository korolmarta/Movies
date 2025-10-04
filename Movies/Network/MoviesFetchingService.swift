import Foundation
import Alamofire

protocol MoviesFetchingServiceProtocol {
    func fetchPopularMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
}

final class MoviesFetchingService: MoviesFetchingServiceProtocol {
    private let baseURL = APIConstants.baseURL
    private let apiKey = APIConstants.apiKey

    func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(baseURL)/movie/popular"
        let parameters: Parameters = [
            "api_key": apiKey,
            "language": "en-US",
            "page": page
        ]

        AF.request(url, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    completion(.success(movieResponse.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
