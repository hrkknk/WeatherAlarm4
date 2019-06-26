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
        //loadできなかった場合はnilが返るようにします
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
            //アーカイブしたalarmをUserDefaultsに保存
            UserDefaults.standard.set(archiveData, forKey: weather.rawValue)
        } catch {
            print(error)
        }
    }
    
    func loadConfig() -> Config? {
        var config: Config?
        if let loadedData = UserDefaults().data(forKey: "config") {
            do {
                config = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedData) as? Config
            } catch {
                print("Load failed")
            }
        }
        return config
    }
    
    func saveConfig(config: Config) {
        do {
            //alarmsを保存するためアーカイブ
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: config, requiringSecureCoding: true)
            //アーカイブしたconfigをUserDefaultsに保存
            UserDefaults.standard.set(archiveData, forKey: "config")
        } catch {
            print(error)
        }
    }
    
}
