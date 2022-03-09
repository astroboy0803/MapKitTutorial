import Foundation
import MapKit
import Contacts

class Artwork: NSObject {
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D

    var mapItem: MKMapItem? {
        guard let locationName = locationName else {
            return nil
        }
        let addressDict: [String: String] = [CNPostalAddressStreetKey: locationName]
        let placemark: MKPlacemark = .init(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem: MKMapItem = .init(placemark: placemark)
        mapItem.name = title
        return mapItem
    }

    var markerTintColor: UIColor {
        switch discipline {
        case "Monument":
            return .red
        case "Mural":
            return .cyan
        case "Plaque":
            return .blue
        case "Sculpture":
            return .purple
        default:
            return .green
        }
    }

    var image: UIImage {
        switch discipline {
        case "Monument":
            return #imageLiteral(resourceName: "Monument")
        case "Mural":
            return #imageLiteral(resourceName: "Mural")
        case "Plaque":
            return #imageLiteral(resourceName: "Plaque")
        case "Sculpture":
            return #imageLiteral(resourceName: "Sculpture")
        default:
            return #imageLiteral(resourceName: "Flag")
        }
    }

    init(title: String?, locationName: String?, discipline: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate

        super.init()
    }

    init?(feature: MKGeoJSONFeature) {
        guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData),
            let properties = json as? [String: Any]
        else {
            return nil
        }
        title = properties["title"] as? String
        locationName = properties["location"] as? String
        discipline = properties["discipline"] as? String
        coordinate = point.coordinate
        super.init()
    }
}

extension Artwork: MKAnnotation {
    var subtitle: String? {
        locationName
    }
}
