//
//  ContentView.swift
//  SwiftUIMapKitTutorial
//
//  Created by BruceHuang on 2022/2/24.
//

import SwiftUI
import MapKit

struct ContentView: View {

    @State private var region: MKCoordinateRegion

    @State private var places: [Place] = []

    @State private var twCities: [TWCity] = []

    @State private var twAreas: [TWArea] = []

    init() {
        region = .init(center: .init(latitude: 23.973875, longitude: 120.982024), span: .init(latitudeDelta: 4, longitudeDelta: 4))
    }

    var body: some View {
//        uikit's map - mkmapview
        VStack {
            Text("latitude = \(region.center.latitude)")
            Text("longitude = \(region.center.longitude)")
            Text("latitudeDelta = \(region.span.latitudeDelta)")
            Text("longitudeDelta = \(region.span.longitudeDelta)")
            UIMapView(region: $region, twCities: $twCities, twAreas: $twAreas)
        }
        .onAppear {
            twCities.append(contentsOf: TWCity.Loader())
            twAreas.append(contentsOf: TWArea.Loader())
        }

//        swiftui's map
//        MapView(region: $region, places: $places)
//        MapExample()
//        PinsView(viewModel: .init(cities: [
//            City(coordinate: .init(latitude: 40.7128, longitude: 74.0060)),
//            City(coordinate: .init(latitude: 37.7749, longitude: 122.4194)),
//            City(coordinate: .init(latitude: 47.6062, longitude: 122.3321))
//        ]))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
