//
//  SetAlarmUseCase.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/02.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import AVFoundation

class AlarmUseCase: NSObject {
    static func createAlarm(date: Date, soundFilePath: String) throws -> AlarmSetting {
        let alarm = AlarmSetting()
        alarm.hour = Calendar.current.component(.hour, from: date)
        alarm.minute = Calendar.current.component(.minute, from: date)
        
        let sound: URL = URL(fileURLWithPath: soundFilePath)
        alarm.sound = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        
        return alarm
    }
    
    static func ringAlarm(alarm: AlarmSetting) -> Bool {
        let sound = alarm.sound
        if(sound == nil){
            print("Failed to ring alarm.")
            return false
        }
        
        sound?.play()
        return true
    }
}
