//
//  AlarmRepository.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/03.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

class AlarmRepository {
    static let sharedInstance: AlarmRepository = AlarmRepository()
    private var alarms: Dictionary = ["sunny": AlarmSetting(),
                              "rainy": AlarmSetting()]
    
    private init() {
    }
    
    func setAlarm(weather: String, alarm: AlarmSetting) {
        if(alarms[weather] == nil){
            print("Weather '\(weather)' is not found in alarms.")
            return
        }
        alarms[weather] = alarm
    }
    
    func getAlarm(weather: String) -> AlarmSetting? {
        return alarms[weather]
    }
}
