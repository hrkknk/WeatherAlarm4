//
//  Alarm.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/02.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import AVFoundation

class Alarm: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(hour, forKey: "hour")
        aCoder.encode(minute, forKey: "minute")
        //TODO: soundを保存できるようにする
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hour = (aDecoder.decodeObject(forKey: "hour") as! Int)
        self.minute = (aDecoder.decodeObject(forKey: "minute") as! Int)
        //TODO: soundのデコード
        self.sound = nil
        self.status = Status.waiting
    }
    
    override init() {
        self.hour = 0
        self.minute = 0
        self.sound = nil
        self.status = Status.waiting
    }

}
