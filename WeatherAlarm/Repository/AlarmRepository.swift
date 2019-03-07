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
    
    var alarms: Dictionary = [Weather.sunny.rawValue: AlarmUseCase.createAlarm(),
                              Weather.rainy.rawValue: AlarmUseCase.createAlarm()]
    
    private override init() {
    }
    
    func setAlarm(weather: Weather, alarm: Alarm) {
        alarms[weather.rawValue] = alarm
    }
    
    func getAlarm(weather: Weather) -> Alarm? {
        return alarms[weather.rawValue]
    }
}
