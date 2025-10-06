import UIKit

final class MovieDetailsViewModel {
    
    private let moviesService: MoviesFetchingServiceProtocol
    
    var movieId: Int = 0
    private(set) var movie: MovieDetails?

    var onDataLoaded: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    var isTrailerAvailable: Bool {
        guard let movie else { return false }
        return movie.trailerURL != nil
    }
    
    init(moviesService: MoviesFetchingServiceProtocol) {
        self.moviesService = moviesService
    }

    func loadMovieDetails() {
        moviesService.fetchMovieDetails(id: movieId) { [weak self] result in
            switch result {
            case .success(let movieResponse):
                
                let country = movieResponse.production_countries.first?.name ?? "Unknown"
                var posterURL: URL?
                if let path = movieResponse.poster_path {
                    posterURL = URL(string: APIConstants.imageURLBase + path)
                }
                
                self?.movie = MovieDetails(
                    title: movieResponse.title,
                    country: country,
                    year: movieResponse.release_date.year ?? "",
                    genres: movieResponse.genres.map { $0.name }.joined(separator: ", "),
                    rating: String(format: "%.1f", movieResponse.vote_average),
                    overview: movieResponse.overview,
                    posterURL: posterURL,
                    trailerURL: nil
                )
                DispatchQueue.main.async {
                    self?.onDataLoaded?()
                }
            case .failure(let error):
                // TODO: Display error alert
                print("❌ Searching movies error:", error)
            }
        }
    }
}
