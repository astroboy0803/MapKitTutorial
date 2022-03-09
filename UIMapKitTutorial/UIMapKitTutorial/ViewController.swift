import UIKit
import MapKit
import CoreLocation

// reference: https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started

class ViewController: UIViewController {

    @IBOutlet private var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    
    private var artworks: [Artwork] = []
    
    private var twCities: [TWCity] = []
    
    private var twAreas: [TWArea] = []
    
    private func loadInitialData() {
        guard
            let fileName = Bundle.main.url(forResource: "PublicArt", withExtension: "geojson"),
            let artworkData = try? Data(contentsOf: fileName)
        else {
            return
        }
        
        do {
            let features = try MKGeoJSONDecoder()
                .decode(artworkData)
                .compactMap({
                    $0 as? MKGeoJSONFeature
                })
            let validWorks = features.compactMap(Artwork.init)
            artworks.append(contentsOf: validWorks)
        } catch {
            print(">>>> decoder fail: \(error)")
        }
    }
    
    // reference: https://stackoverflow.com/questions/15177400/using-ibaction-buttons-to-zoom-mapview
    @IBAction private func zoomIn(sender: UIButton) {
        var region = self.mapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        print(">>>> zoomIn new span = \(region.span)")
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction private func zoomOut(sender: UIButton) {
        var region = self.mapView.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180)
        print(">>>> zoomOut new span = \(region.span)")
        self.mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
//        // custom view: register
//        mapView.register(ArtworkMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        mapView.isRotateEnabled = false
        
        mapView.delegate = self
        
//        artSetup()
        twSetup()
    }
    
    private func artSetup() {
        // 設定初始座標
        let initLocation: CLLocation = .init(latitude: 21.282778, longitude: -157.829444)
        self.mapView.centerToLocation(location: initLocation)

        //self.mapView.userTrackingMode = .follow

        // 設定邊界 - 地圖可以滾動的範圍
        let oahuCenter: CLLocation = .init(latitude: 21.4765, longitude: -157.9647)
        let region: MKCoordinateRegion = .init(center: oahuCenter.coordinate, latitudinalMeters: 50000, longitudinalMeters: 60000)
        mapView.setCameraBoundary(.init(coordinateRegion: region), animated: true)

        // 設定zoom的範圍
        let zoomRange: MKMapView.CameraZoomRange? = .init(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        // 設定annotation
        let artwork: Artwork = .init(title: "King David Kalakaua", locationName: "Waikiki Gateway Park", discipline: "Sculpture", coordinate: .init(latitude: 21.283921, longitude: -157.831661))
        mapView.addAnnotation(artwork)

        mapView.delegate = self

        loadInitialData()
        mapView.addAnnotations(artworks)
    }
    
    private func twSetup() {
        let initLocation: CLLocationCoordinate2D = .init(latitude: 23.973875, longitude: 120.982024)
        self.mapView.setRegion(.init(center: initLocation, span: .init(latitudeDelta: 5, longitudeDelta: 5)), animated: false)
        
        twCities.append(contentsOf: TWCity.Loader())
        mapView.addAnnotations(twCities)
        
        twAreas.append(contentsOf: TWArea.Loader())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        實現動畫
//        mapView.isUserInteractionEnabled = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let initLocation: CLLocation = .init(latitude: 23.973875, longitude: 120.982024)
//            self.mapView.centerToLocation(location: initLocation)
//            self.mapView.isUserInteractionEnabled = true
//        }
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        print(">>>> regionWillChangeAnimated = \(mapView.region.span)")
//        print(">>>> visible = \(mapView.visibleMapRect)")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //print(">>>> regionDidChangeAnimated = \(mapView.region.span)")
        //print(">>>> visible = \(mapView.visibleMapRect)")
        let span = mapView.region.span
        mapView.removeAnnotations(mapView.annotations)
        print("span = \(span)")
        if span.latitudeDelta >= 3 {
            mapView.addInVisibleAnnotations(twCities)
        } else /*if span.latitudeDelta >= 1*/ {
            mapView.addInVisibleAnnotations(twAreas)
        }
    }
    
//    // 動畫在動的時候會不斷呼叫, 上面是動畫完成才會被呼叫
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        print("didchange")
//    }
    
    // show annotation before call
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case let twCity as TWCity: // 如果要取值的話, 可以用case let接
            let identifier = "twCity"
            var view: CircleAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CircleAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = .init(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        case let twArea as TWArea:
            let identifier = "twArea"
            var view: CircleAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CircleAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = .init(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        case is Artwork:
            let identifier = "artwork"
            var view: ArtworkView
            //var view: ArtworkMarkerView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? ArtworkView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = .init(annotation: annotation, reuseIdentifier: identifier)
    //            view.canShowCallout = true
    //            view.calloutOffset = .init(x: -5, y: 5)
    //            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    //            view.leftCalloutAccessoryView = UIButton(type: .contactAdd)
    //            view.markerTintColor = .systemOrange
    //            view.glyphImage = .init(systemName: "house.fill")
            }
            return view
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let circle = view as? CircleAnnotationView, let annotation = circle.annotation else {
            return
        }
        switch annotation {
        case let twCity as TWCity:
            let span: MKCoordinateSpan = .init(latitudeDelta: 0.5, longitudeDelta: 0.5)
            mapView.removeAnnotations(mapView.annotations)
            mapView.setRegion(.init(center: twCity.coordinate, span: span), animated: true)
            print(mapView.region.span.longitudeDelta / 5)
        case let twArea as TWArea:
            let twCity = twCities.first(where: { twArea.countycode == $0.countycode })
            let center = twCity?.coordinate ?? twArea.coordinate
            let span: MKCoordinateSpan = .init(latitudeDelta: 5, longitudeDelta: 5)
            mapView.removeAnnotations(mapView.annotations)
            mapView.setRegion(.init(center: center, span: span), animated: true)
            
            print(mapView.region.span.latitudeDelta * 5)
        default:
            break
        }
    }
    
    // tap annotation's AccessoryView after call
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let artwork = view.annotation as? Artwork else {
            return
        }
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        artwork.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}

// MARK: - MKMapView
private extension MKMapView {
    func centerToLocation(location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion: MKCoordinateRegion = .init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
    func addInVisibleAnnotations(_ annotations: [MKAnnotation]) {
        self.addAnnotations(annotations.filter {
            self.visibleMapRect.contains(MKMapPoint($0.coordinate))
        })
    }
}
