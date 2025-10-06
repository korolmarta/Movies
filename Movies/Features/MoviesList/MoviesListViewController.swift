import UIKit

final class MoviesListViewController: UIViewController {
    static let identifier = "MoviesListViewController"
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var refreshControl = UIRefreshControl()
    private var viewModel: MoviesListViewModel
    
    private var footerLoadingView: UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        footerView.backgroundColor = .clear
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = footerView.center
        spinner.startAnimating()
        footerView.addSubview(spinner)
        return footerView
    }
    
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: MoviesListViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleInternetConnection()
        setupUI()
        setupTableView()
        setupRefreshControl()
        setupSearchController()
        bindViewModel()
        
        viewModel.firstMoviesLoading()
    }
    
    private func setupUI() {
        title = "Popular Movies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down.square"),
            style: .plain,
            target: self,
            action: #selector(showSortOptions)
        )
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.register(
            UINib(nibName: MovieTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: MovieTableViewCell.identifier
        )
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSearchController() {
        searchBar.placeholder = "Search for a movie..."
        searchBar.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onErrorOccurred = { [weak self] message in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: message)
            }
        }
        
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.reloadSections = {
            self.tableView.tableFooterView = self.viewModel.isLoading ? self.footerLoadingView : nil
        }
    }
    
    private func handleInternetConnection() {
        NetworkMonitor.shared.startMonitoring()
        NetworkMonitor.shared.onStatusChange = { [weak self] isConnected in
            guard let self = self else { return }
            if !isConnected {
                self.showOfflineAlert()
            }
        }
    }
    
    private func showMovieDetails(for movie: Movie) {
        let detailsVC = DependencyContainer.shared.container.forceResolve(MovieDetailsViewController.self)
        detailsVC.setMoviePreviewInfo(movie)
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    private func showOfflineAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "You are offline. Please, enable your Wi-Fi or connect using cellular data.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func refreshData() {
        viewModel.reloadMovies()
    }
    
    @objc private func showSortOptions() {
        let alert = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        MoviesSortOption.allCases.forEach { option in
            let action = UIAlertAction(title: option.title, style: .default) { _ in
                self.viewModel.sortMovies(sortBy: option)
            }
            if option == viewModel.currentSort {
                action.setValue(UIImage.init(systemName: "checkmark"), forKey: "image")
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.moviesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = viewModel.movies[indexPath.row]
        let genres = viewModel.getGenres(of: movie)
        
        cell.configure(with: movie, genres: genres)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadNextPageIfNeeded(currentIndex: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = viewModel.movies[indexPath.row]
        showMovieDetails(for: movie)
    }
}

// MARK: - UISearchBarDelegate
extension MoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        
        if trimmed.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
            viewModel.reloadMovies()
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            viewModel.searchMovies(query: trimmed)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
