import UIKit

final class PosterViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        imageView.image = image
        imageView.frame = scrollView.bounds
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
