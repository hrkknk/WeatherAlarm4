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
    var isTried: Bool
    var isRang: Bool
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(hour, forKey: "hour")
        aCoder.encode(minute, forKey: "minute")
        aCoder.encode(soundFileName, forKey: "soundFileName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hour = (aDecoder.decodeObject(forKey: "hour") as? Int)
        self.minute = (aDecoder.decodeObject(forKey: "minute") as? Int)
        self.soundFileName = (aDecoder.decodeObject(forKey: "soundFileName") as? String)
        self.isTried = false
        self.isRang = false
    }
    
    override init() {
        self.hour = 0
        self.minute = 0
        self.soundFileName = ""
        self.isTried = false
        self.isRang = false
    }
    
    func setTime(dateTime: Date) {
        self.hour = Calendar.current.component(.hour, from: dateTime)
        self.minute = Calendar.current.component(.minute, from: dateTime)
    }
    
    func getTimeAsString() -> String {
        return "\(self.hour!):\(String(format: "%02d", self.minute!))"
    }
    
    func isRingTime(dateTime: Date) -> Bool {
        let nowHour = Calendar.current.component(.hour, from: Date())
        let nowMinute = Calendar.current.component(.minute, from: Date())
        if(nowHour == self.hour && nowMinute == self.minute) {
            return true
        }
        return false
    }
}
