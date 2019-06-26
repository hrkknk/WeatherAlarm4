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
    var soundFileName: String?
    var status: Status
    enum Status {
        case waiting
        case timeHasCome
        case rang
        case misfired
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(hour, forKey: "hour")
        aCoder.encode(minute, forKey: "minute")
        aCoder.encode(soundFileName, forKey: "soundFileName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hour = (aDecoder.decodeObject(forKey: "hour") as? Int)
        self.minute = (aDecoder.decodeObject(forKey: "minute") as? Int)
        self.soundFileName = (aDecoder.decodeObject(forKey: "soundFileName") as? String)
        self.status = Status.waiting
    }
    
    override init() {
        self.hour = 0
        self.minute = 0
        self.soundFileName = ""
        self.status = Status.waiting
    }
    
    func setTime(dateTime: Date) {
        self.hour = Calendar.current.component(.hour, from: dateTime)
        self.minute = Calendar.current.component(.minute, from: dateTime)
    }
}
