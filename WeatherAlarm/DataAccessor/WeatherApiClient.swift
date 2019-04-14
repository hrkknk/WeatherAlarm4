//
//  WeatherApiClient.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/03/07.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Alamofire
import SwiftyJSON

class WeatherApiClient: NSObject {
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
                    weather.id = responseJson["weather"][0]["id"].stringValue
                    weather.description = responseJson["weather"][0]["description"].stringValue
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
}
