//
//  Weather.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/02.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

class Weather {
    var description: String?
}

enum WeatherType: String, CaseIterable {
    case sunny
    case rainy
}
