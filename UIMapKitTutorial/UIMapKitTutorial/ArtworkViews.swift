import MapKit

class ArtworkMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else {
                return
            }
            canShowCallout = true
            calloutOffset = .init(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            markerTintColor = artwork.markerTintColor
            if let letter = artwork.discipline?.first {
                glyphText = String(letter)
            }
        }
    }
}

class ArtworkView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else {
                return
            }
            canShowCallout = true
            calloutOffset = .init(x: -5, y: 5)

            let mapButton: UIButton = .init(frame: .init(origin: .zero, size: .init(width: 48, height: 48)))
            mapButton.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
            rightCalloutAccessoryView = mapButton

            let detailLabel: UILabel = .init()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = artwork.subtitle
            detailCalloutAccessoryView = detailLabel

//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            image = artwork.image
        }
    }
}

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

class CircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Get the Graphics Context
        if let context = UIGraphicsGetCurrentContext() {
            
            // Set the circle outerline-width
            context.setLineWidth(1);
            
            // Set the circle outerline-colour
            UIColor.red.set()
            
            // Create Circle
            let center = CGPoint(x: rect.maxX/2, y: rect.maxY/2)
            let radius = rect.maxX/2
            context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
            
            // Draw
            context.fillPath()
//            context.strokePath()
        }
    }
}
