//
//  Alarm.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/02.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import AVFoundation

class Alarm {
    var hour: Int?
    var minute: Int?
    var sound: AVAudioPlayer?
    var status: Status = Status.waiting
    enum Status {
        case waiting
        case timeHasCome
        case rang
        case misfired
    }
}
