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
    
    @State private var places: [Place]
    
    init() {
        region = .init(center: .init(latitude: 23.973875, longitude: 120.982024), span: .init(latitudeDelta: 4, longitudeDelta: 4))
        
        places = [
            .init(name: "台北市", latitude: 25.03746, longitude: 121.564558)
        ]
    }
    
    var body: some View {
//        uikit's map - mkmapview
        VStack {
            Text("latitude = \(region.center.latitude), longitude = \(region.center.longitude)")
            Text("latitudeDelta = \(region.span.latitudeDelta), longitudeDelta = \(region.span.longitudeDelta)")
            UIMapView(region: $region, places: $places)
        }
        .onAppear {
            places.append(.init(name: "台中市", latitude: 24.138504, longitude: 120.678434))
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
