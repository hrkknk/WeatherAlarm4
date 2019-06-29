//
//  WeatherDataAccessorProtocol.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/06/27.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

protocol WeatherDataAccessorProtocol {
    func getWeather(geoLocation: GeoLocation) -> Weather
}
