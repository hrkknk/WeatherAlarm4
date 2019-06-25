//
//  CacheDataAccessor.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/06/26.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class CacheDataAccessor: CacheDataAccessorProtocol {
    
    func loadAlarm(weather: Weather.Condition) -> Alarm? {
        var alarm: Alarm?
        if let loadedData = UserDefaults().data(forKey: weather.rawValue) {
            do {
                alarm = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedData) as? Alarm
            } catch {
                print("Load failed")
            }
        }
        return alarm
    }
    
    func saveAlarm(weather: Weather.Condition, alarm: Alarm) {
        do {
            //alarmsを保存するためアーカイブ
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: alarm, requiringSecureCoding: true)
            //アーカイブしたalarmsをUserDefaultsに保存
            UserDefaults.standard.set(archiveData, forKey: weather.rawValue)
        } catch {
            print(error)
        }
    }
}
