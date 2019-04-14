//
//  AlarmUseCase.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/02.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import AVFoundation

class AlarmUseCase {
    // AVAudioPlayerはプロパティとして保持しておかないと動かないらしい
    static var player: AVAudioPlayer?
    
    static func createAlarm(date: Date = Date(),
                            soundFileName: String = "学校のチャイム01") -> Alarm {
        let alarm = Alarm()
        alarm.hour = Calendar.current.component(.hour, from: date)
        alarm.minute = Calendar.current.component(.minute, from: date)
        alarm.soundFileName = soundFileName
        alarm.status = Alarm.Status.waiting

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
        
        let soundFilePath = Bundle.main.path(forResource: alarm.soundFileName!, ofType: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFilePath), fileTypeHint:nil)
        } catch {
            alarm.status = Alarm.Status.misfired
            print("Failed to ring sound; \(error)")
            return false
        }

        player?.play()
        alarm.status = Alarm.Status.rang
        return true
    }
    
    static func ringAlarmForcibly(alarm: Alarm){
        let soundFilePath = Bundle.main.path(forResource: alarm.soundFileName!, ofType: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFilePath), fileTypeHint:nil)
        } catch {
            alarm.status = Alarm.Status.misfired
            print("Failed to create alarm; \(error)")
            return
        }

        player?.play()
        alarm.status = Alarm.Status.rang
    }
    
    static func stopAlarm(alarm: Alarm){
        alarm.sound?.stop()
    }
}
