//
//  AlarmStandbyViewController.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2019/01/04.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import UIKit
import CoreLocation

class AlarmStandbyViewController: UIViewController {
    
    // MARK: - Properties
    private let alarmRepository: AlarmRepository = AlarmRepository.sharedInstance
    private let weatherApiClient: WeatherApiClient = WeatherApiClient.sharedInstance
    private var timer: Timer?
    private var sunnyAlarm: Alarm?
    private var rainyAlarm: Alarm?
    var latitude: String?
    var longitude: String?

    // 位置情報取得用オブジェクト
    let locationManager = CLLocationManager()

    //MARK: - Outlets
    @IBOutlet weak var sunnyAlarmTime: UILabel!
    @IBOutlet weak var rainyAlarmTime: UILabel!

    //MARK: - Actions
    @IBAction func backToPrevious(_ sender: UIBarButtonItem) {
        timer?.invalidate()
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
        
        sunnyAlarm = alarmRepository.getAlarm(weatherCondition: Weather.Condition.sunny)
        rainyAlarm = alarmRepository.getAlarm(weatherCondition: Weather.Condition.rainy)
        sunnyAlarmTime.text = AlarmUseCase.getAlarmTimeAsString(alarm: sunnyAlarm!)
        rainyAlarmTime.text = AlarmUseCase.getAlarmTimeAsString(alarm: rainyAlarm!)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(observeAlarmTimer), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 別画面に遷移する時にはtimerを破棄しておく
        timer?.invalidate()
    }
    
    @objc private func observeAlarmTimer() {
        print("timer ticked: \(Date())")
        
        let isRainyAlarmRingTime = AlarmUseCase.changeStatusIfTimeHasCome(alarm: rainyAlarm!)
        let isSunnyAlarmRingTime = AlarmUseCase.changeStatusIfTimeHasCome(alarm: sunnyAlarm!)
        
        // rainy も sunny も鳴る時間になっていないなら処理しない
        if (rainyAlarm!.status != Alarm.Status.timeHasCome
            && sunnyAlarm!.status != Alarm.Status.timeHasCome) {
            return
        }
        
        // rainy か sunny が鳴らし終わっているなら処理しない
        if (rainyAlarm!.status == Alarm.Status.rang
            || sunnyAlarm!.status == Alarm.Status.rang) {
            return
        }
        
        let geoLocation = GeoLocation()
        geoLocation.latitude = latitude
        geoLocation.longitude = longitude

        var weatherCondition = Weather.Condition.unsure
        // 通信可能な場合のみ天気情報を取得する。ネット未接続なら時間が来たアラームを鳴らす。
        if NetworkChecker.reachable() {
            let weather = self.weatherApiClient.getWeather(geoLocation: geoLocation)
            weatherCondition = WeatherUseCase.getWeatherCondition(weatherId: weather.id)
        }

        if isRainyAlarmRingTime {
            if weatherCondition == Weather.Condition.unsure || sunnyAlarm?.status == Alarm.Status.misfired {
                AlarmUseCase.ringAlarmForcibly(alarm: rainyAlarm!)
                print("'Rainy' alarmed forcibly.")
            } else {
                AlarmUseCase.ringAlarm(alarm: rainyAlarm!, currentWeather: weatherCondition, targetWeather: Weather.Condition.rainy) ?
                    print("'Rainy' alarmed.") : print("'Rainy' misfired.")
            }
        }
        
        if isSunnyAlarmRingTime {
            if weatherCondition == Weather.Condition.unsure || rainyAlarm?.status == Alarm.Status.misfired {
                AlarmUseCase.ringAlarmForcibly(alarm: sunnyAlarm!)
                print("'Sunny' alarmed forcibly.")
            } else {
                AlarmUseCase.ringAlarm(alarm: sunnyAlarm!, currentWeather: weatherCondition, targetWeather: Weather.Condition.sunny) ?
                    print("'Sunny' alarmed.") : print("'Sunny' misfired.")
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
