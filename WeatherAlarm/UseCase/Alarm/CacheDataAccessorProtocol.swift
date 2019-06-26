//
//  CacheDataAccessorProtocol.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/06/26.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

protocol CacheDataAccessorProtocol {
    func loadAlarm(weather: Weather.Condition) -> Alarm?
    func saveAlarm(weather: Weather.Condition, alarm: Alarm)
}
