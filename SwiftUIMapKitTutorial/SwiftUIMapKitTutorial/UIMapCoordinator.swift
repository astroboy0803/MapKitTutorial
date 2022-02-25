import Foundation
import MapKit

class UIMapCoordinator: NSObject {
    private let uiMapView: UIMapView
    
    init(uiMapView: UIMapView) {
        self.uiMapView = uiMapView
    }
}

extension UIMapCoordinator: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print(">>>> \(#function)")
        self.uiMapView.region = mapView.region
    }
}
