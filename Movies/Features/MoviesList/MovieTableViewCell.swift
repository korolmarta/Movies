import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        posterImageView.contentMode = .scaleAspectFill
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        
        setupLabels()
        setupShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        contentView.layer.shadowColor = UIColor.label.cgColor
        posterImageView.addBlackGradient(position: .top)
        posterImageView.addBlackGradient(position: .bottom)
    }
    
    private func setupShadow() {
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 2, height: 3)
        contentView.layer.shadowColor = UIColor.label.cgColor
    }
    
    private func setupLabels() {
        titleLabel.font = .systemFont(ofSize: 21, weight: .bold)
        genresLabel.font = .systemFont(ofSize: 17, weight: .bold)
        ratingLabel.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    func configure(with movie: Movie, genres: String) {
        var movieYear: String = ""
        if let year = movie.releaseDate?.year {
            movieYear = " (\(year))"
        }
        titleLabel.text = movie.title + movieYear
        genresLabel.text = genres
        let rating = "⭐️ " + String(format: "%.1f", movie.voteAverage)
        ratingLabel.text = movie.voteAverage > 0 ? rating : ""
        
        if let path = movie.posterPath {
            let url = URL(string: APIConstants.imageURLBase + path)
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.contentMode = .scaleAspectFit
            posterImageView.image = UIImage(systemName: "film")
        }
    }
}
