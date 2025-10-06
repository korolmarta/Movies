import Foundation

final class MoviesListViewModel {
    private let moviesService: MoviesFetchingServiceProtocol
    
    private var genresMap: [Int: String] = [:]
    private var genres: String?
    private(set) var movies: [Movie] = []
    
    private(set)var currentSort: MoviesSortOption = .popularityDesc
    private var currentQuery: String?
    
    private var currentPage = 1
    private var totalPages = 1
    private(set) var isLoading = false {
        didSet {
            reloadSections?()
        }
    }
    
    var moviesCount: Int {
        movies.count
    }
    
    var onMoviesUpdated: (() -> ())?
    var reloadSections: (() -> ())?
    
    init(moviesService: MoviesFetchingServiceProtocol) {
        self.moviesService = moviesService
    }
    
    private func resetVariables() {
        currentQuery = nil
        currentPage = 1
        movies.removeAll()
    }
    
    private func loadGenres() {
        moviesService.fetchGenres { [weak self] result in
            self?.reloadMovies()
            switch result {
            case .success(let genresMap):
                self?.genresMap = genresMap
            case .failure(let error):
                // TODO: Display error alert
                print("❌ Fetching genres error:", error.localizedDescription)
            }
        }
    }
    
    private func loadMovies() {
        guard !isLoading else { return }
        isLoading = true
        
        self.moviesService.fetchMovies(page: self.currentPage, sortBy: self.currentSort) { [weak self] result in
            switch result {
            case .success(let response):
                self?.totalPages = response.totalPages
                self?.movies += response.results
                self?.onMoviesUpdated?()
                self?.isLoading = false
            case .failure(let error):
                // TODO: Display error alert
                print("❌ Fetching movies error:", error.localizedDescription)
            }
        }
    }
    
    private func loadMoviesWithCurrenQuery() {
        guard !isLoading, let query = currentQuery else { return }
        isLoading = true
        moviesService.searchMovies(query: query, page: currentPage) { [weak self] response in
            switch response {
            case .success(let results):
                self?.totalPages = results.totalPages
                self?.movies += results.results
                self?.onMoviesUpdated?()
                self?.isLoading = false
            case .failure(let error):
                // TODO: Display error alert
                print("❌ Searching movies error:", error)
            }
        }
    }
    
    func searchMovies(query: String) {
        guard !isLoading, !query.isEmpty else { return }
        resetVariables()
        currentQuery = query
        loadMoviesWithCurrenQuery()
    }
    
    func firstMoviesLoading() {
        guard !genresMap.isEmpty else {
            loadGenres()
            return
        }
        loadMovies()
    }
    
    func reloadMovies() {
        resetVariables()
        onMoviesUpdated?()
        loadMovies()
    }
    
    func loadNextPageIfNeeded(currentIndex: Int) {
        guard !isLoading, currentPage < totalPages, currentIndex == movies.count - 1 else {
            return
        }
        currentPage += 1
        if currentQuery != nil {
            loadMoviesWithCurrenQuery()
        } else {
            loadMovies()
        }
    }
    
    func sortMovies(sortBy: MoviesSortOption) {
        currentSort = sortBy
        reloadMovies()
    }

    func getGenres(of movie: Movie) -> String {
        let genreNames = movie.genreIDs.compactMap { genresMap[$0] }
        return genreNames.joined(separator: ", ")
    }
}
