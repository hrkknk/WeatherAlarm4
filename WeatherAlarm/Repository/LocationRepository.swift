//
//  LocationRepository.swift
//  WeatherAlarm
//
//  Created by Ryo Fujimoto on 2019/05/11.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationRepositoryDelegate {
    func setLatitudeAndLongitude()
}

class LocationRepository: NSObject, CLLocationManagerDelegate, LocationRepositoryProtocol {
    static let sharedInstance: LocationRepository = LocationRepository()
    
    private var location: GeoLocation?
    
    private var locationManager: CLLocationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    private override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()  // only execute 'status == .notDetermied'
    }
    
    func startUpdatingLocation() {
        print("start location updates")
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("stop location updates")
        self.locationManager.stopUpdatingLocation()
    }
    
    func getLocation() -> GeoLocation? {
        return self.location
    }
    
    // MARK: - 位置情報取得
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[locations.count - 1]
        // horizontalAccuracy（水平方向の位置の精度）がマイナスの場合は有効な値でないので切り捨てる
        if currentLocation!.horizontalAccuracy > 0 {
            location = GeoLocation()
            location!.latitude = String(currentLocation!.coordinate.latitude)
            location!.longitude = String(currentLocation!.coordinate.longitude)
        }
    }

    //MARK: - 位置情報取得エラー時
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

