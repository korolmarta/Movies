import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {
    static let identifier = "MovieDetailsViewController"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var metaLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
    
    private func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPoster))
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(tap)
    }
    
    func setMovieID(_ movieID: Int) {
        viewModel.movieId = movieID
    }
    
    private func bindViewModel() {
        viewModel.onDataLoaded = { [weak self] in
            self?.showMovieInfo()
        }
    }
    
    func showMovieInfo() {
        // TODO: refactor
        titleLabel.text = viewModel.movie?.title
        metaLabel.text = (viewModel.movie?.country ?? "") + ", " + (viewModel.movie?.year ?? "")
        genresLabel.text = viewModel.movie?.genres
        ratingLabel.text = "Rating: " + (viewModel.movie?.rating ?? "0.0")
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

    @objc private func didTapPoster() {
        guard let image = posterImageView.image else { return }
        let vc = PosterViewController()
        vc.image = image
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
