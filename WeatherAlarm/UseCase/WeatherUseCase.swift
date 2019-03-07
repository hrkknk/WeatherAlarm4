//
//  WeatherUseCase.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/07.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

class WeatherUseCase {
    static func getCondition(weatherId: String) -> Weather {
        // id 2xx, 3xx, 4xx, 5xx and 6xx are 'Rainy'
        // https://openweathermap.org/weather-conditions
        if weatherId.hasPrefix("2") ||
            weatherId.hasPrefix("3") ||
            weatherId.hasPrefix("4") ||
            weatherId.hasPrefix("5") ||
            weatherId.hasPrefix("6") {
            return Weather.rainy
        }
        // otherwise 'Sunny'
        return Weather.sunny
    }
}
