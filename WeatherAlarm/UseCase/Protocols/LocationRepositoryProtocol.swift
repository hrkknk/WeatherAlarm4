//
//  LocationRepositoryProtocol.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/06/30.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

protocol LocationRepositoryProtocol {
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func getLocation() -> GeoLocation?
}
