//
//  AppDelegate.swift
//  MapKitTutorial
//
//  Created by BruceHuang on 2022/2/23.
//

import UIKit
import MapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // test mkmappoint and mkmaprect
        // latitude, longitude同數學座標計法(latitude越大越上, longitude越大越右)
        
        let point1: MKMapPoint = .init(.init(latitude: 23, longitude: 120))
        let point2: MKMapPoint = .init(.init(latitude: 22, longitude: 118))
        let mkRect: MKMapRect = .init(x: min(point1.x, point2.x), y: min(point1.y, point2.y), width: abs(point1.x-point2.x), height: abs(point1.y-point2.y))
        print(mkRect)
        
        let mapRect = [point1, point2]
            .map { MKMapRect(origin: $0, size: .init()) }
            .reduce(MKMapRect.null) { rect, point in
                rect.union(point)
            }
        print(mapRect)
        
        let point3: MKMapPoint = .init(.init(latitude: 22.5, longitude: 120.5))
        print(mapRect.contains(point3))
        let inRect: MKMapRect = .init(origin: point3, size: .init())
        print(mapRect.contains(inRect))
        
        let point4: MKMapPoint = .init(.init(latitude: 21.5, longitude: 119.5))
        print(mapRect.contains(point4))
        let outRect: MKMapRect = .init(origin: point4, size: .init())
        print(mapRect.contains(outRect))
        
        print(mapRect.intersects(inRect))
        print(mapRect.intersects(outRect))
        
        let iMapRect = [point3, point4]
            .map { MKMapRect(origin: $0, size: .init()) }
            .reduce(MKMapRect.null) { rect, point in
                rect.union(point)
            }
        print(iMapRect)
        print(mapRect.intersects(iMapRect))
        
        let point5: MKMapPoint = .init(.init(latitude: 21, longitude: 119))
        print(mapRect.contains(point5))
        let ooutRect: MKMapRect = .init(origin: point5, size: .init())
        print(mapRect.contains(ooutRect))
        
        let oMapRect = [point4, point5]
            .map { MKMapRect(origin: $0, size: .init()) }
            .reduce(MKMapRect.null) { rect, point in
                rect.union(point)
            }
        print(oMapRect)
        print(mapRect.intersects(oMapRect))
        
        let point6: MKMapPoint = .init(.init(latitude: 23.5, longitude: 121.5))
        print(mapRect.contains(point6))
        let oooutRect: MKMapRect = .init(origin: point6, size: .init())
        print(mapRect.contains(oooutRect))
        
        let bMapRect = [point5, point6]
            .map { MKMapRect(origin: $0, size: .init()) }
            .reduce(MKMapRect.null) { rect, point in
                rect.union(point)
            }
        print(bMapRect)
        print(mapRect.contains(bMapRect))
        print(mapRect.intersects(bMapRect))
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
