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
    private let alarmRepository: AlarmRepository = AlarmRepository.sharedInstance
    private let weatherApiClient: WeatherApiClient = WeatherApiClient.sharedInstance
    private var sunnyAlarm: Alarm?
    private var rainyAlarm: Alarm?
    private var isRungAlarm: Bool = false
    var latitude: String?
    var longitude: String?

    // 位置情報取得用オブジェクト
    let locationManager = CLLocationManager()

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
        
        sunnyAlarm = alarmRepository.getAlarm(weather: Weather.sunny)
        rainyAlarm = alarmRepository.getAlarm(weather: Weather.rainy)
        sunnyAlarmTime.text = AlarmUseCase.getAlarmTimeAsString(alarm: sunnyAlarm!)
        rainyAlarmTime.text = AlarmUseCase.getAlarmTimeAsString(alarm: rainyAlarm!)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(observeAlarmTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func observeAlarmTimer() {
        let isRainyAlarmRingTime = AlarmUseCase.isAlarmRingTime(alarm: rainyAlarm!)
        let isSunnyAlarmRingTime = AlarmUseCase.isAlarmRingTime(alarm: sunnyAlarm!)
        
        if(isRungAlarm || (!isRainyAlarmRingTime && !isSunnyAlarmRingTime)) {
            return
        }
        
        let geoLocation = GeoLocation()
        geoLocation.latitude = latitude
        geoLocation.longitude = longitude

        let weatherData = weatherApiClient.getWeatherData(geoLocation: geoLocation)
        if weatherData.id == nil {
            return
        }
        
        let weather = WeatherUseCase.getCondition(weatherId: weatherData.id!)
        
        if isRainyAlarmRingTime {
            if weather == Weather.rainy {
                isRungAlarm = AlarmUseCase.ringAlarm(alarm: rainyAlarm!)
                print("'Rainy' alarmed.")
            }
        } else if isSunnyAlarmRingTime {
            if weather == Weather.sunny {
                isRungAlarm = AlarmUseCase.ringAlarm(alarm: sunnyAlarm!)
                print("'Sunny' alarmed.")
            }
        }
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
