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
    
    var alarms: Dictionary = [WeatherType.sunny.rawValue: AlarmUseCase.createAlarm(),
                              WeatherType.rainy.rawValue: AlarmUseCase.createAlarm()]
    
    private override init() {
    }
    
    func setAlarm(weatherType: WeatherType, alarm: Alarm) {
        alarms[weatherType.rawValue] = alarm
    }
    
    func getAlarm(weatherType: WeatherType) -> Alarm? {
        return alarms[weatherType.rawValue]
    }
}
