//
//  ConfigRepository.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2019/04/14.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation
class ConfigRepository: NSObject, NSSecureCoding {
    static let sharedInstance: ConfigRepository = ConfigRepository()
    
    static var supportsSecureCoding: Bool = true
    
    private var isSnoozeOn: Bool = false
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(isSnoozeOn, forKey: "isSnoozeOn")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isSnoozeOn = (aDecoder.decodeObject(forKey: "isSnoozeOn") as! Bool)
    }
    
    private override init() {
        self.isSnoozeOn = false
    }
    
    func setSnoozeOn(isSnoozeOn: Bool) {
        self.isSnoozeOn = isSnoozeOn
        //TODO: save
    }
    
    func getSnoozeOn() -> Bool {
        return self.isSnoozeOn
    }
    
    func loadConfig() {
        //TODO: load
    }
}
