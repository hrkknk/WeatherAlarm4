//
//  Config.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2019/04/14.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class Config: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var isSnoozeOn: Bool
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(isSnoozeOn, forKey: "isSnoozeOn")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isSnoozeOn = (aDecoder.decodeObject(forKey: "isSnoozeOn") as? Bool) ?? false
    }
    
    override init() {
        self.isSnoozeOn = false
    }
}
