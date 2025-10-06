import UIKit

final class MovieDetailsViewModel {
    
    private let moviesService: MoviesFetchingServiceProtocol
    private(set) var movie: MovieDetails?
    
    var movieId: Int = 0
    var onDataLoaded: (() -> Void)?
    
    var isTrailerAvailable: Bool {
        guard let movie else { return false }
        return movie.trailerURL != nil
    }
    
    init(moviesService: MoviesFetchingServiceProtocol) {
        self.moviesService = moviesService
    }

    func loadMovieDetails() {
        moviesService.fetchMovieDetails(id: movieId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let movieResponse):
                var posterURL: URL?
                if let path = movieResponse.poster_path {
                    posterURL = URL(string: APIConstants.imageURLBase + path)
                }
                
                var meta: String = ""
                if let country = movieResponse.production_countries.first?.name {
                    meta += country
                }
                if let year = movieResponse.release_date.year {
                    meta.isEmpty ? (meta += year) : (meta += ", \(year)")
                }
                
                self.moviesService.fetchTrailerURL(id: self.movieId) { trailerURL in
                    self.movie = MovieDetails(
                        title: movieResponse.title,
                        meta: meta,
                        genres: movieResponse.genres.map { $0.name }.joined(separator: ", "),
                        rating: "Rating: " + String(format: "%.1f", movieResponse.vote_average),
                        overview: movieResponse.overview,
                        posterURL: posterURL,
                        trailerURL: trailerURL
                    )
                    
                    self.onDataLoaded?()
                }
            case .failure(let error):
                // TODO: Display error alert
                print("❌ Searching movies error:", error)
            }
        }
    }
}
