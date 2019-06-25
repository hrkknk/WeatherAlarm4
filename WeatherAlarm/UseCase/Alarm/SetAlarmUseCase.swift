//
//  SetAlarmUseCase.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/06/26.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class SetAlarmUseCse {
    private var alarmRepository: AlarmRepositoryProtocol
    private var cacheDataAccessor: CacheDataAccessorProtocol
    
    init(alarmRepository: AlarmRepositoryProtocol,
         cacheDataAccessor: CacheDataAccessorProtocol) {
        self.alarmRepository = alarmRepository
        self.cacheDataAccessor = cacheDataAccessor
    }
    
    func load() {
        for weather in Weather.Condition.allCases {
            var alarm = cacheDataAccessor.loadAlarm(weather: weather)
            if alarm == nil {
                alarm = Alarm()
                alarm!.setTime(dateTime: Date())
                alarm!.soundFileName = "学校のチャイム01"
            }
            alarmRepository.setAlarm(weather: weather, alarm: alarm!)
        }
    }
    
    func getAlarmTime(weather: Weather.Condition) -> Date {
        let alarm = alarmRepository.getAlarm(weather: weather)
        return Calendar.current.date(from: DateComponents(hour: alarm.hour, minute: alarm.minute))!
    }
    
    func updateAlarmTime(weather: Weather.Condition, dateTime: Date) {
        let alarm = alarmRepository.getAlarm(weather: weather)
        alarm.setTime(dateTime: dateTime)
        alarmRepository.setAlarm(weather: weather, alarm: alarm)
        cacheDataAccessor.saveAlarm(weather: weather, alarm: alarm)
    }
}
