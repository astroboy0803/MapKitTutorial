import Foundation
import MapKit
import Combine

class UIMapCoordinator: NSObject {

    private let uiMapView: UIMapView

    init(uiMapView: UIMapView) {
        self.uiMapView = uiMapView
    }
}

extension UIMapCoordinator: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(">>>> \(#function)")
        uiMapView.updateAnnotations(mapView: mapView)
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print(">>>> \(#function)")
        self.uiMapView.region = mapView.region
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        switch view.annotation {
        case let twCity as TWCity:
            self.uiMapView.region = .init(center: twCity.coordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
        case let twArea as TWArea:
            let twCity = uiMapView.twCities.first(where: { twArea.countycode == $0.countycode })
            let center = twCity?.coordinate ?? twArea.coordinate
            self.uiMapView.region = .init(center: center, span: .init(latitudeDelta: 4, longitudeDelta: 4))
        default:
            break
        }
    }

    // custom view - circle
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case let twCity as TWCity:
            let identifier = String(describing: TWCity.self)
            let view: CircleAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CircleAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = .init(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        case let twArea as TWArea:
            let identifier = String(describing: TWArea.self)
            let view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = .init(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        default:
            return nil
        }
    }
}
