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
                            soundFilePath: String = Bundle.main.path(forResource: "学校のチャイム01", ofType: "mp3")!) -> Alarm {
        let alarm = Alarm()
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
    
    static func getAlarmTimeAsDate(alarm: Alarm) -> Date {
        return Calendar.current.date(from: DateComponents(hour: alarm.hour, minute: alarm.minute))!
    }
    
    static func getAlarmTimeAsString(alarm: Alarm) -> String {
        return "\(alarm.hour!):\(String(format: "%02d", alarm.minute!))"
    }
    
    static func changeStatusIfTimeHasCome(alarm: Alarm) -> Bool {
        if alarm.status != Alarm.Status.waiting {
            return false
        }
        
        let nowHour = Calendar.current.component(.hour, from: Date())
        let nowMinute = Calendar.current.component(.minute, from: Date())
        if(nowHour == alarm.hour && nowMinute == alarm.minute) {
            alarm.status = Alarm.Status.timeHasCome
            return true
        }
        return false
    }
    
    static func ringAlarm(alarm: Alarm, currentWeather: Weather.Condition, targetWeather: Weather.Condition) -> Bool {
        if alarm.status != Alarm.Status.timeHasCome {
            return false
        }
        
        if currentWeather != targetWeather {
            alarm.status = Alarm.Status.misfired
            return false
        }
        
        let sound = alarm.sound
        if sound == nil {
            alarm.status = Alarm.Status.misfired
            print("Failed to ring alarm.")
            return false
        }
        
        sound?.play()
        alarm.status = Alarm.Status.rang
        return true
    }
    
    static func ringAlarmAnyway(alarm: Alarm){
        alarm.sound?.play()
        alarm.status = Alarm.Status.rang
    }
}
