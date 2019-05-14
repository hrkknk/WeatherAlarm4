//
//  ConfigUseCase.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2019/04/14.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class ConfigUseCase {
    static func setSnoozeOn() {
        Config.sharedInstance.isSnoozeOn = true
    }
}
