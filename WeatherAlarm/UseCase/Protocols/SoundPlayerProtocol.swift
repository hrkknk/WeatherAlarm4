//
//  SoundPlayerProtocol.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/06/27.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

protocol SoundPlayerProtocol {
    func playAlarmSound(alarm: Alarm) -> Bool
    func stop()
}
