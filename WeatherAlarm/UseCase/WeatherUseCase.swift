//
//  WeatherUseCase.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/07.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

class WeatherUseCase {
    static func getWeatherCondition(weatherId: String?) -> Weather.Condition {
        if weatherId == nil {
            return Weather.Condition.unsure
        }
        
        // id 2xx, 3xx, 4xx, 5xx and 6xx are 'Rainy'
        // https://openweathermap.org/weather-conditions
        if weatherId!.hasPrefix("2") ||
            weatherId!.hasPrefix("3") ||
            weatherId!.hasPrefix("4") ||
            weatherId!.hasPrefix("5") ||
            weatherId!.hasPrefix("6") {
            return Weather.Condition.rainy
        }
        // otherwise 'Sunny'
        return Weather.Condition.sunny
    }
    
    static func getWeatherText(weatherCondition: Weather.Condition) -> String {
        switch (weatherCondition) {
        case Weather.Condition.sunny:
            return "Sunny"
        case Weather.Condition.rainy:
            return "Rainy"
        default:
            return "Unsure"
        }
    }
    
    static func getWeatherTextColor(weatherCondition: Weather.Condition) -> (red: Int, green: Int, blue: Int) {
        switch (weatherCondition) {
        case Weather.Condition.sunny:
            return (255, 181, 30)
        case Weather.Condition.rainy:
            return (10, 132, 255)
        default:
            return (255, 255, 255)
        }
    }
}
