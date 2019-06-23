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

class LocationRepository: NSObject, CLLocationManagerDelegate {
    static let sharedInstance: LocationRepository = LocationRepository()
    
    private var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var delegate: LocationRepositoryDelegate?
    
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
    
    // MARK: - 位置情報取得
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[locations.count - 1]
        setLatitudeAndLongitude()
    }

    //MARK: - 位置情報取得エラー時
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    private func setLatitudeAndLongitude() {
        guard let delegate = self.delegate else { return }
        delegate.setLatitudeAndLongitude()
    }
}

