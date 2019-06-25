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
    private var alarms: Dictionary = [Weather.Condition.sunny.rawValue: AlarmUseCase.createAlarm(),
                                      Weather.Condition.rainy.rawValue: AlarmUseCase.createAlarm()]
    
    func setAlarm(weather: Weather.Condition, alarm: Alarm) {
        alarms[weather.rawValue] = alarm
    }
    
    func getAlarm(weather: Weather.Condition) -> Alarm {
        return alarms[weather.rawValue]!
    }
    
    func containsAlarms(status: Alarm.Status) -> Bool {
        for alarm in alarms {
            if alarm.value.status == status {
                return true
            }
        }
        return false
    }
    
    func updateAllAlarmStatus() {
        for alarm in alarms {
            let _ = AlarmUseCase.changeStatusIfTimeHasCome(alarm: alarm.value)
        }
    }
    
    func getTimeComingWeatherAlarm() -> (weather: Weather.Condition, alarm: Alarm)? {
        for alarm in alarms {
            if alarm.value.status == Alarm.Status.timeHasCome {
                // enum変換できない謎のkeyだったらunsureとして扱う
                let weatherCondition = Weather.Condition(rawValue: alarm.key) ?? Weather.Condition.unsure
                // 仮にtimeHasComeなアラームが複数あったとしても、鳴らすのは1つなので最初に見つかったものだけ返す
                return (weatherCondition, alarm.value)
            }
        }
        return nil
    }
    
    func snoozeAllAlarms(addSeconds: Int) {
        for var alarm in alarms {
            AlarmUseCase.startSnooze(alarm: &alarm.value, addSeconds: addSeconds)
            alarms[alarm.key] = alarm.value
        }
    }
}
