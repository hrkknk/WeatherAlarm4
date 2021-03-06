//
//  Weather.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/07.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

class Weather {
    var condition: Condition?
    var description: String?
    var place: String?
    enum Condition: String, CaseIterable {
        case sunny
        case rainy
    }
}
