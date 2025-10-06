import UIKit

extension UIImageView {
    enum GradientPosition {
        case top
        case bottom
        
        var points: (start: CGFloat, end: CGFloat) {
            switch self {
            case .bottom:
                return (0.8, 0.0)
            case .top:
                return (0.0, 0.8)
            }
        }
    }
    
    func addBlackGradient(position: GradientPosition) {
        let middlePoint = position == .bottom ? 0.2 : 0.8
        let identifier = position == .bottom ? "bottomGradien" : "topGradien"
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(position.points.start).cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor,
            UIColor.black.withAlphaComponent(position.points.end).cgColor
        ]
        gradientLayer.locations = [0.0, NSNumber(value: middlePoint), 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = bounds
        gradientLayer.name = identifier
        layer.sublayers?.removeAll(where: { $0.name == identifier })
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
