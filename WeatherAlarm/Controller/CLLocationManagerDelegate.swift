//
//  CLLocationManagerDelegate.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2019/01/13.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import CoreLocation

extension AlarmStandbyViewController: CLLocationManagerDelegate {
    
    //MARK: - 位置情報取得
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 最新の位置情報だけ取得
        let location = locations[locations.count - 1]
        
        // horizontalAccuracy（水平方向の位置の精度）がマイナスの場合は有効な値でないので切り捨てる
        if location.horizontalAccuracy > 0 {
            // 位置情報が取得できたら取得をやめる、電池消耗防止
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
            
            // 緯度・経度を文字列に変換してセット
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
            
            //TODO: lat, lngは取得不可の場合があるので、guardする
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

