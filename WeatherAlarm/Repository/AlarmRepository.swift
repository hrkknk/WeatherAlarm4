//
//  AlarmRepository.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/03.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class AlarmRepository: NSObject, AlarmRepositoryProtocol {
    static let sharedInstance: AlarmRepository = AlarmRepository()
    private var alarms: Dictionary = [Weather.Condition.sunny.rawValue: Alarm(),
                                      Weather.Condition.rainy.rawValue: Alarm()]
    
    private override init() { }
    
    func setAlarm(weather: Weather.Condition, alarm: Alarm) {
        alarms[weather.rawValue] = alarm
    }
    
    func getAlarm(weather: Weather.Condition) -> Alarm {
        return alarms[weather.rawValue]!
    }
    
    func getNotTriedAlarms() -> [Alarm] {
        var results = [Alarm]()
        for weather in Weather.Condition.allCases {
            let alarm = alarms[weather.rawValue]!
            if alarm.isTried {
                results.append(alarm)
            }
        }
        return results
    }
    
    func getRingTimingAlarms(dateTime: Date) -> [Alarm] {
        var results = [Alarm]()
        for weather in Weather.Condition.allCases {
            let alarm = alarms[weather.rawValue]!
            if alarm.isRingTime(dateTime: dateTime) {
                results.append(alarm)
            }
        }
        return results
    }
    
    func getRangAlarms() -> [Alarm] {
        var results = [Alarm]()
        for weather in Weather.Condition.allCases {
            let alarm = alarms[weather.rawValue]!
            if alarm.isRang {
                results.append(alarm)
            }
        }
        return results
    }
}
