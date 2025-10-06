import UIKit
import Kingfisher
import SafariServices

class MovieDetailsViewController: UIViewController {
    static let identifier = "MovieDetailsViewController"
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var metaLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var trailerButton: UIButton!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    var viewModel: MovieDetailsViewModel!
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: MovieDetailsViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadMovieDetails()
    }
    
    func setMoviePreviewInfo(_ movie: Movie) {
        title = movie.title
        viewModel.movieId = movie.id
    }
    
    private func setupUI() {
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
        trailerButton.setImage(UIImage(systemName: "play.rectangle.fill", withConfiguration: config), for: .normal)
        trailerButton.tintColor = .label
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPoster))
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(tap)
    }
    
    private func bindViewModel() {
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.showMovieInfo()
            }
        }
    }

    private func showMovieInfo() {
        titleLabel.text = viewModel.movie?.title
        metaLabel.text = viewModel.movie?.meta
        metaLabel.isHidden = viewModel.movie?.meta == nil
        genresLabel.text = viewModel.movie?.genres
        genresLabel.isHidden = viewModel.movie?.genres == nil
        ratingLabel.text = viewModel.movie?.rating
        descriptionLabel.text = viewModel.movie?.overview
        
        if let url = viewModel.movie?.posterURL {
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.contentMode = .scaleAspectFit
            posterImageView.image = UIImage(systemName: "film")
            posterImageView.backgroundColor = .quaternarySystemFill.withAlphaComponent(0.2)
        }
        trailerButton.isHidden = !viewModel.isTrailerAvailable
    }
    
    @IBAction private func trailerButtonTapped(_ sender: Any) {
        guard let url = viewModel.movie?.trailerURL else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    @objc private func didTapPoster() {
        guard let image = posterImageView.image else { return }
        let vc = PosterViewController()
        vc.image = image
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
