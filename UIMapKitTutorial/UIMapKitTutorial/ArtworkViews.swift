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
