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

    @State private var places: [Place] = [
        .init(name: "台北市", latitude: 25.0375671, longitude: 121.5654698),
        .init(name: "台南市", latitude: 22.992995799999999, longitude: 120.18520150000001)
    ]

    @State private var twCities: [TWCity] = []

    @State private var twAreas: [TWArea] = []

    init() {
        region = .init(center: .init(latitude: 23.973875, longitude: 120.982024), span: .init(latitudeDelta: 4, longitudeDelta: 4))
    }

    var body: some View {
//        uikit's map - mkmapview
        ZStack {
            VStack {
                Text("latitude = \(region.center.latitude)")
                Text("longitude = \(region.center.longitude)")
                Text("latitudeDelta = \(region.span.latitudeDelta)")
                Text("longitudeDelta = \(region.span.longitudeDelta)")
                MapView(region: $region, places: $places)
                //UIMapView(region: $region, twCities: $twCities, twAreas: $twAreas)
            }
            BottomSheetView()
//            SlideOverCard {
//                VStack {
//                    Text("Maitland Bay")
//                        .font(.headline)
//                        .padding()
//                    Spacer()
//                }
//                .frame(width: UIScreen.main.bounds.width)
//            }
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
