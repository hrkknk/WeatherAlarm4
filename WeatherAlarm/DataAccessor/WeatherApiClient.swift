//
//  WeatherApiClient.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/07.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Alamofire
import SwiftyJSON

class WeatherApiClient: NSObject, WeatherDataAccessorProtocol {
    static let sharedInstance: WeatherApiClient = WeatherApiClient()
    
    private let weatherUrl = "http://api.openweathermap.org/data/2.5/weather"
    private let appId = "3486f122e589efd3e860f3a10775ce47"
    
    private override init() {
    }
    
    func getWeather(geoLocation: GeoLocation) -> Weather {
        let weather: Weather = Weather()
        let semaphore = DispatchSemaphore(value: 0)
        let queue     = DispatchQueue.global(qos: .utility)
        
        let parameters = ["lat" : geoLocation.latitude!,
                         "lon" : geoLocation.longitude!,
                         "appid" : appId]
        
        Alamofire.request(weatherUrl, method: .get, parameters: parameters).responseJSON(queue: queue) {
            response in
            if response.result.isSuccess {
                // response.result.valueはオプショナル型だが、if文で結果を確認しているのでforce unwrappedしてよい
                let responseJson: JSON = JSON(response.result.value!)
                print(responseJson)
                
                if responseJson["cod"] == 200 {
                    let weatherId = responseJson["weather"][0]["id"].stringValue
                    weather.condition = self.getWethaerCondition(weatherId: weatherId)
                    weather.description = responseJson["weather"][0]["description"].stringValue
                    weather.place = responseJson["name"].stringValue
                } else {
                    // WeatherAPI にアクセスできたものの、正常応答が得られなかった場合
                    print("Response condition is not 200: \(responseJson["cod"])")
                }
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            semaphore.signal()
        }
        semaphore.wait()
        
        return weather
    }
    
    private func getWethaerCondition(weatherId: String?) -> Weather.Condition? {
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
}
