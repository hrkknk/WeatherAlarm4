//
//  AlarmStandbyViewController.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2019/01/04.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class AlarmStandbyViewController: UIViewController {
    
    // MARK: - Properties
    var alarm: Alarm?
    var timer: Timer?
    var currentTime: String?
    var secondsForSunnyAlarm: Int = 0
    var secondsForRainyAlarm: Int = 0
    var remainForSunnyAlarm: Int = 0
    var remainForRainyAlarm: Int = 0
    var isRungAlarm: Bool = false
    var latitude: String?
    var longitude: String?
    var currentLocationWeather: String?
    
    // Dictionary型を定義して、緯度・経度・APIKeyをセット
    var geoCoordinatesInfo: [String : String]?
    
    // 位置情報取得用オブジェクト
    let locationManager = CLLocationManager()
    
    // 天気予報API
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "3486f122e589efd3e860f3a10775ce47"

    //MARK: - Outlets
    @IBOutlet weak var sunnyAlarmTime: UILabel!
    @IBOutlet weak var rainyAlarmTime: UILabel!
    
    
    //MARK: - Actions
    @IBAction func backToPrevious(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // 位置情報取得のためのデリゲート
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //前の画面(AlarmViewController)のprepare()で渡してもらったalarmから時刻を抽出
        sunnyAlarmTime.text = self.alarm?.getSunnyAlarmTimeAsString()
        rainyAlarmTime.text = self.alarm?.getRainyAlarmTimeAsString()
        
        //アラームを鳴らす時刻までの秒数を取得
        self.secondsForSunnyAlarm = calculateInterval(userAwakeTime: (self.alarm?.sunnyAlarmTime)!)
        self.secondsForRainyAlarm = calculateInterval(userAwakeTime: (self.alarm?.rainyAlarmTime)!)
        
        //更新用の変数を用意
        self.remainForSunnyAlarm = self.secondsForSunnyAlarm
        self.remainForRainyAlarm = self.secondsForRainyAlarm
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCurrentTime() {
        if(!isRungAlarm) {
            // どちらかを鳴らす時間になったら、天気情報を取得する
            if(self.remainForSunnyAlarm <= 0 || self.remainForRainyAlarm <= 0) {
                geoCoordinatesInfo = ["lat" : latitude!, "lon" : longitude!, "appid" : APP_ID]
                getWeatherData(url: WEATHER_URL, geoCoordinatesInfo: geoCoordinatesInfo!)
                
                if(self.remainForSunnyAlarm <= 0) {
                    switch(currentLocationWeather) {
                    case "clear sky", "few clouds", "scattered clouds":
                        print("Good Weather: \(remainForSunnyAlarm)")
                        self.alarm?.playSound()
                        isRungAlarm = true
                    default:
                        // 訳のわからない天気情報だったので、とりあえず鳴らしておく
                        self.alarm?.playSound()
                        isRungAlarm = true
                        print("I need your current weather condition!")
                    }
                }
                
                if(self.remainForRainyAlarm <= 0) {
                    switch(currentLocationWeather) {
                    case "broken clouds", "shower rain", "rain", "thunderstorm", "snow", "mist":
                        print("Bad Weather: \(remainForRainyAlarm)")
                        self.alarm?.playSound()
                        isRungAlarm = true
                    default:
                        // 訳のわからない天気情報だったので、とりあえず鳴らしておく
                        self.alarm?.playSound()
                        isRungAlarm = true
                        print("I need your current weather condition!¡")
                    }
                }
            } else {
                // 時間になるまで1秒ずつ減らす
                self.remainForSunnyAlarm -= 1
                self.remainForRainyAlarm -= 1
            }
        }
        
//        if(!isRungAlarm && self.remainForSunnyAlarm <= 0) {
//            //TODO: Sunnyアラーム鳴らす判定
//            geoCoordinatesInfo = ["lat" : latitude!, "lon" : longitude!, "appid" : APP_ID]
//            getWeatherData(url: WEATHER_URL, geoCoordinatesInfo: geoCoordinatesInfo!)
//
//            //TODO: あとでもっとスマートにする
//            if(currentLocationWeather == "clear sky" || currentLocationWeather == "few clouds" || currentLocationWeather == "scattered clouds") {
//                print("Good Weather: \(remainForSunnyAlarm)")
//                self.alarm?.playSound()
//                isRungAlarm = true
//            }
//        } else {
//            self.remainForSunnyAlarm -= 1
//        }
//
//        if(!isRungAlarm && self.remainForRainyAlarm <= 0) {
//            //TODO: Rainyアラーム鳴らす判定
//            geoCoordinatesInfo = ["lat" : latitude!, "lon" : longitude!, "appid" : APP_ID]
//            getWeatherData(url: WEATHER_URL, geoCoordinatesInfo: geoCoordinatesInfo!)
//
//            //TODO: broken cloudsどうする？？
//            if(currentLocationWeather == "broken clouds" || currentLocationWeather == "shower rain" || currentLocationWeather == "rain" || currentLocationWeather == "thunderstorm" || currentLocationWeather == "snow") {
//                print("Bad Weather: \(remainForRainyAlarm)")
//                self.alarm?.playSound()
//                isRungAlarm = true
//            }
//        } else {
//            self.remainForRainyAlarm -= 1
//        }
    }

    private func calculateInterval(userAwakeTime:Date) -> Int {
        //タイマーの時間を計算する
        var interval = Int(userAwakeTime.timeIntervalSinceNow)
        print("interval: \(interval)")
        
        if interval < 0 {
            //日をまたぐと過去の時刻と比較してしまうので、24時間(86400秒)足す
            interval = 86400 + interval
        }
        
        //DatePickerで設定した時刻は秒単位まで指定できていないので、最大59秒ずれる。回避策として、その分引いてやる。
        let calendar =  Calendar.current
        let seconds = calendar.component(.second, from: userAwakeTime)
        return interval - seconds
    }
    
    // Networking
    func getWeatherData(url: String, geoCoordinatesInfo: [String : String]) {
        Alamofire.request(url, method: .get, parameters: geoCoordinatesInfo).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                
                // response.result.valueはオプショナル型だが、if文で結果を確認しているのでforce unwrappedしてよい
                let weatherJSON: JSON = JSON(response.result.value!)
                print(weatherJSON)
                
                // クロージャの中でメソッドを呼び出すにはself句を呼び出すメソッドの前につける必要あり
                self.parsingJSON(json: weatherJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    func parsingJSON(json: JSON) {
        currentLocationWeather = json["weather"][0]["description"].stringValue
        
        print(json["weather"][0]["description"].stringValue)
        print(json["name"].stringValue)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
