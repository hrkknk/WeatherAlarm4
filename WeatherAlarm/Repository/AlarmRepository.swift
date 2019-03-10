//
//  AlarmRepository.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/03.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class AlarmRepository: NSObject {
    static let sharedInstance: AlarmRepository = AlarmRepository()
    private let defaultSoundFilePath = Bundle.main.path(forResource: "学校のチャイム01", ofType: "mp3")!
    
    private var alarms: Dictionary = [Weather.Condition.sunny.rawValue: AlarmUseCase.createAlarm(),
                              Weather.Condition.rainy.rawValue: AlarmUseCase.createAlarm()]
    
    private override init() {
    }
    
    func setAlarm(weatherCondition: Weather.Condition, alarm: Alarm) {
        alarms[weatherCondition.rawValue] = alarm
    }
    
    func getAlarm(weatherCondition: Weather.Condition) -> Alarm? {
        return alarms[weatherCondition.rawValue]
    }
}
