//
//  AlarmRepositoryProtocol.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/06/26.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

protocol AlarmRepositoryProtocol {
    func getAlarm(weather: Weather.Condition) -> Alarm
    func getNotTriedAlarms() -> [Alarm]
    func getRingTimingAlarms(dateTime: Date) -> [Alarm]
    func getRangAlarms() -> [Alarm]
    func setAlarm(weather: Weather.Condition, alarm: Alarm)
}
