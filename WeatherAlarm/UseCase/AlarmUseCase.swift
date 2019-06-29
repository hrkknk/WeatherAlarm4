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

    static func startSnooze(alarm: inout Alarm, addSeconds: Int) {
        let date = AlarmUseCase.getAlarmTimeAsDate(alarm: alarm)
        alarm = createAlarm(date: date.addingTimeInterval(Double(addSeconds)))
    }
}
