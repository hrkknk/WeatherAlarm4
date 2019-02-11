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
        
        //ブラックUI化
        view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)

        // 位置情報取得のためのデリゲート
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //前の画面(AlarmViewController)のprepare()で渡してもらったalarmから時刻を抽出
        sunnyAlarmTime.text = self.alarm?.getSunnyAlarmTimeAsString()
        rainyAlarmTime.text = self.alarm?.getRainyAlarmTimeAsString()
        
        //更新用の変数を用意
        self.remainForSunnyAlarm = self.secondsForSunnyAlarm
        self.remainForRainyAlarm = self.secondsForRainyAlarm
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(observeAlarmTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func observeAlarmTimer() {
        let now = Date();
        
        let isTimeRainyAlarm = areEqualHourMinute(date1: now, date2: alarm!.rainyAlarmTime)
        let isTimeSunnyAlarm = areEqualHourMinute(date1: now, date2: alarm!.sunnyAlarmTime)
        
        if(isRungAlarm || (!isTimeRainyAlarm && !isTimeSunnyAlarm)) {
            return
        }
        
        geoCoordinatesInfo = ["lat" : latitude!, "lon" : longitude!, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, geoCoordinatesInfo: geoCoordinatesInfo!)
        
        if(isTimeRainyAlarm) {
            switch(currentLocationWeather) {
            case "clear sky", "few clouds", "scattered clouds":
                print("Good Weather: \(remainForSunnyAlarm)")
                self.alarm?.playSound()
            default:
                // 訳のわからない天気情報だったので、とりあえず鳴らしておく
                self.alarm?.playSound()
                print("I need your current weather condition!")
            }
            isRungAlarm = true;
        } else if(isTimeSunnyAlarm) {
            switch(currentLocationWeather) {
            case "clear sky", "few clouds", "scattered clouds":
                print("Good Weather: \(remainForSunnyAlarm)")
                self.alarm?.playSound()
            default:
                // 訳のわからない天気情報だったので、とりあえず鳴らしておく
                self.alarm?.playSound()
                print("I need your current weather condition!")
            }
            isRungAlarm = true;
        }
    }
    
    func areEqualHourMinute(date1: Date, date2: Date) -> Bool {
        let hour1 = Calendar.current.component(.hour, from: date1)
        let minute1 = Calendar.current.component(.minute, from: date1)
        let hour2 = Calendar.current.component(.hour, from: date2)
        let minute2 = Calendar.current.component(.minute, from: date2)
        if(hour1 == hour2 && minute1 == minute2) {
            return true
        }
        return false
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
