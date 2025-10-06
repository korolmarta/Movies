import UIKit

final class EmptyStateView: UIView {
    private let imageView = UIImageView()
    private let label = UILabel()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String, systemImageName: String = "tray") {
        super.init(frame: .zero)
        
        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        
        label.text = message
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
