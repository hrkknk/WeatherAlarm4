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
    private var alarms: Dictionary = [Weather.Condition.sunny.rawValue: AlarmUseCase.createAlarm(),
                                      Weather.Condition.rainy.rawValue: AlarmUseCase.createAlarm()]

    
    func setAlarm(weatherCondition: Weather.Condition, alarm: Alarm) {
        alarms[weatherCondition.rawValue] = alarm
        do {
            //alarmsを保存するためアーカイブ
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: alarm, requiringSecureCoding: true)
            //アーカイブしたalarmsをUserDefaultsに保存
            UserDefaults.standard.set(archiveData, forKey: weatherCondition.rawValue)
        } catch {
            print(error)
        }
    }
    
    func getAlarm(weatherCondition: Weather.Condition) -> Alarm? {
        return alarms[weatherCondition.rawValue]
    }
    
    func loadAlarm(weatherCondition: Weather.Condition) {
        if let loadedData = UserDefaults().data(forKey: weatherCondition.rawValue) {
            do {
                let tmp = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedData) as? Alarm
                if(tmp != nil) {
                    alarms[weatherCondition.rawValue] = tmp
                }
            } catch {
                print("Load failed")
            }
        }
    }
}
