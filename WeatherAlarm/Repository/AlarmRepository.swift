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
    
    private var alarms: Dictionary = [WeatherCondition.sunny.rawValue: AlarmUseCase.createAlarm(),
                              WeatherCondition.rainy.rawValue: AlarmUseCase.createAlarm()]
    
    private override init() {
    }
    
    func setAlarm(weatherCondition: WeatherCondition, alarm: Alarm) {
        alarms[weatherCondition.rawValue] = alarm
    }
    
    func getAlarm(weatherCondition: WeatherCondition) -> Alarm? {
        return alarms[weatherCondition.rawValue]
    }
}
