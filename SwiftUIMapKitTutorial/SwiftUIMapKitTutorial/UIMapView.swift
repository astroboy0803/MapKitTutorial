import SwiftUI
import MapKit

struct UIMapView: UIViewRepresentable {
    
    @Binding var region: MKCoordinateRegion
    
    @Binding var places: [Place]
    
    /// Creates the view object and configures its initial state.
    /// The system calls this method only once, when it creates your view for the first time.
    /// uiview初始化設定
    func makeUIView(context: Context) -> MKMapView {
        
        let mkMapView: MKMapView = .init()
        
        // 旋轉
        mkMapView.isRotateEnabled = false
        // map能否3d檢視 -> 兩指向上
        mkMapView.isPitchEnabled = false
        
        // 縮放
//        mkMapView.isZoomEnabled = false
        // 移動
//        mkMapView.isScrollEnabled = false
        // map格式 -> 預設standard
//        mkMapView.mapType = .standard
        
        mkMapView.delegate = context.coordinator
        
        return mkMapView
    }
    
    /// Updates the state of the specified view with new information from SwiftUI.
    /// When the state of your app changes, SwiftUI updates the portions of your
    /// interface affected by those changes. SwiftUI calls this method for any
    /// changes affecting the corresponding UIKit view. Use this method to
    /// update the configuration of your view to match the new state information
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print(">>>> update view")
        if region != uiView.region {
            print(">>>> update region")
            uiView.setRegion(region, animated: true)
        }
        if places.count != uiView.annotations.count {
            let annotation = uiView.annotations as? [MKPointAnnotation] ?? []
            uiView.removeAnnotations(annotation)
            uiView.addAnnotations(places.map({ place -> MKPointAnnotation in
                let location: MKPointAnnotation = .init()
                location.coordinate = place.coordinate
                location.title = place.name
                location.subtitle = place.id.uuidString
                return location
            }))
        }
    }
    
    func makeCoordinator() -> UIMapCoordinator {
        .init(uiMapView: self)
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center == rhs.center && lhs.span == rhs.span
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}

extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.longitudeDelta == rhs.longitudeDelta && lhs.latitudeDelta == rhs.latitudeDelta
    }
}
