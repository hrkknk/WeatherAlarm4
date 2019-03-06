//
//  AlarmUseCase.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/02.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import AVFoundation

class AlarmUseCase {
    static func createAlarm(date: Date = Date(),
                            soundFilePath: String = Bundle.main.path(forResource: "学校のチャイム01", ofType: "mp3")!) -> AlarmSetting {
        let alarm = AlarmSetting()
        alarm.hour = Calendar.current.component(.hour, from: date)
        alarm.minute = Calendar.current.component(.minute, from: date)
        
        let sound: URL = URL(fileURLWithPath: soundFilePath)
        do {
            alarm.sound = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("Failed to create alarm; soundFilePath not found; \(soundFilePath).")
        }
        
        return alarm
    }
    
    static func getAlarmDate(alarm: AlarmSetting) -> Date {
        return Calendar.current.date(from: DateComponents(hour: alarm.hour, minute: alarm.minute))!
    }
    
    static func getAlarmTimeAsString(alarm: AlarmSetting) -> String {
        return "\(alarm.hour!):\(alarm.minute!)"
    }
    
    static func isAlarmRingTime(alarm: AlarmSetting) -> Bool {
        let nowHour = Calendar.current.component(.hour, from: Date())
        let nowMinute = Calendar.current.component(.minute, from: Date())
        if(nowHour == alarm.hour && nowMinute == alarm.minute) {
            return true
        }
        return false
    }
    
    static func ringAlarm(alarm: AlarmSetting) -> Bool {
        let sound = alarm.sound
        if sound == nil {
            print("Failed to ring alarm.")
            return false
        }
        
        sound?.play()
        return true
    }
}
