import SwiftUI
import MapKit
import Contacts

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapView: View {

    @Binding var region: MKCoordinateRegion

    @Binding var places: [Place]

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, annotationItems: places) { item in
                // MapPin(coordinate: item.coordinate)

                // MapMarker(coordinate: item.coordinate)
                
                // 可判斷item種類決定是否顯示, 但是操作起來很卡(對比mkmapview)
                MapAnnotation(coordinate: item.coordinate, anchorPoint: .init(x: 0.5, y: 0.5)) {
                    Button {
                        // open map app
//                            let addressDict: [String: String] = [CNPostalAddressStreetKey: "sub"]
//
//                            let placemark: MKPlacemark = .init(coordinate: region.center, addressDictionary: addressDict)
//                            let mapItem: MKMapItem = .init(placemark: placemark)
//                            mapItem.name = "title"
//                            let launchOptions = [
//                                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
//                            ]
//                            mapItem.openInMaps(launchOptions: launchOptions)

                        // zoom in/out -> animation動畫處理
                        let coordinate = item.coordinate
                        let span: MKCoordinateSpan = .init(latitudeDelta: region.span.latitudeDelta / 2, longitudeDelta: region.span.longitudeDelta / 2)
                        region = .init(center: coordinate, span: span)
                        places = [
                            .init(name: "彰化縣", latitude: 24.07555, longitude: 120.545069),
                            .init(name: "桃園市", latitude: 25.02, longitude: 121.31)
                        ]
                    } label: {
                        Circle()
                            .fill(.red)
                            .frame(width: 60, height: 60)
                    }
                }
            }
            .animation(.interactiveSpring(), value: region)
            .onChange(of: region) { newValue in
                print(">>>> \(newValue)")
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {

    @State private static var region: MKCoordinateRegion =
        .init(center: .init(latitude: 23.973875, longitude: 120.982024), span: .init(latitudeDelta: 4, longitudeDelta: 4))

    @State private static var places: [Place] = [
        .init(name: "台北市", latitude: 25.03746, longitude: 121.564558)
    ]

    static var previews: some View {
        MapView(region: $region, places: $places)
    }
}

// MARK: - SwiftUI's View Map
// struct City: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
// }
//
// struct MapExample: View {
//    @State private var cities: [City] = [
//        City(coordinate: .init(latitude: 40.7128, longitude: 74.0060)),
//        City(coordinate: .init(latitude: 37.7749, longitude: 122.4194)),
//        City(coordinate: .init(latitude: 47.6062, longitude: 122.3321))
//    ]
//
//    @State private var userTrackingMode: MapUserTrackingMode = .follow
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 25.7617, longitude: 80.1918),
//        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
//    )
//
//    var body: some View {
//        Map(coordinateRegion: $region, annotationItems: cities) { city in
//            MapAnnotation(
//                coordinate: city.coordinate,
//                anchorPoint: CGPoint(x: 0.5, y: 0.5)
//            ) {
//                Circle()
//                    .strokeBorder(.red, lineWidth: 10)
//                    .frame(width: 20, height: 20)
//            }
//        }
//    }
// }
//
// final class PinsViewModel: ObservableObject {
//    @Published var mapRect = MKMapRect()
//    let cities: [City]
//
//    init(cities: [City]) {
//        self.cities = cities
//    }
//
//    func fit() {
//        let points = cities.map(\.coordinate).map(MKMapPoint.init)
//        mapRect = points.reduce(MKMapRect.null) { rect, point in
//            let newRect = MKMapRect(origin: point, size: MKMapSize())
//            return rect.union(newRect)
//        }
//    }
// }
//
// struct PinsView: View {
//    @ObservedObject var viewModel: PinsViewModel
//
//    // another initializer 可以依據加入的pin位置算出最適合的中間點
//    var body: some View {
//        Map(
//            mapRect: $viewModel.mapRect,
//            annotationItems: viewModel.cities
//        ) { city in
//            MapPin(coordinate: city.coordinate, tint: .accentColor)
//        }.onAppear(perform: viewModel.fit)
//    }
// }
