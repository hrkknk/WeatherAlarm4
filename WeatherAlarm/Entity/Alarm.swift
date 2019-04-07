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
        aCoder.encode(sound, forKey: "sound")
        aCoder.encode(status, forKey: "status")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hour = (aDecoder.decodeObject(forKey: "hour") as! Int)
        self.minute = (aDecoder.decodeObject(forKey: "minute") as! Int)
        self.sound = (aDecoder.decodeObject(forKey: "sound") as! AVAudioPlayer)
        self.status = (aDecoder.decodeObject(forKey: "status") as! Status)
    }
    
    override init() {
        self.hour = 0
        self.minute = 0
        self.sound = nil
        self.status = Status.waiting
    }

}
