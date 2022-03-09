import UIKit
import MapKit

class CircleAnnotationView: MKAnnotationView {
    private let countLabel = UILabel()

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            switch newValue {
            case let twCity as TWCity:
                countLabel.text = twCity.countyname
            case let twArea as TWArea:
                countLabel.text = twArea.townname
            default:
                break
            }
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 30
        layer.backgroundColor = UIColor.systemYellow.cgColor
        
        addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
