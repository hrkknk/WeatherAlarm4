//
//  AlarmStandbyViewController.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2019/01/04.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import UIKit
import CoreLocation

class AlarmStandbyViewController: UIViewController, LocationRepositoryDelegate {
    
    // MARK: - Properties
    private let alarmRepository: AlarmRepository = AlarmRepository.sharedInstance
    private let weatherApiClient: WeatherApiClient = WeatherApiClient.sharedInstance
    private let configRepository: ConfigRepository = ConfigRepository.sharedInstance
    private let locationRepository: LocationRepository = LocationRepository.sharedInstance
    private var timer: Timer?
    
    var latitude: String?
    var longitude: String?

    //MARK: - Outlets
    @IBOutlet weak var sunnyAlarmTime: UILabel!
    @IBOutlet weak var rainyAlarmTime: UILabel!
    @IBOutlet weak var snoozeAlarmButton: UIButton!
    @IBOutlet weak var stopAlarmButton: UIButton!
    @IBOutlet weak var alarmingView: UIView!
    @IBOutlet weak var alarmingWeather: UILabel!
    @IBOutlet weak var alarmingTime: UILabel!
    @IBOutlet weak var alarmingLocation: UILabel!
    
    //MARK: - Actions
    @IBAction func backToPrevious(_ sender: UIBarButtonItem) {
        timer?.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func snoozeAlarm(_ sender: UIButton) {
        //アラームを止めるだけ。画面遷移はしない
        AlarmUseCase.stopAlarm()
        self.snoozeAlarmButton.isEnabled = false
        self.snoozeAlarmButton.setTitle("SNOOZING", for: .normal)
    }
    
    @IBAction func stopAlarm(_ sender: UIButton) {
        //アラームを止めて前画面に戻る
        AlarmUseCase.stopAlarm()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //ブラックUI化
        view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        alarmingView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        
        //viewDidLoad()でhiddenにしているので最初は押せない
        //observeAlarmTimer()でアラームが鳴った時にhidden解除
        self.stopAlarmButton.isHidden = true
        self.snoozeAlarmButton.isHidden = true
        self.alarmingView.isHidden = true

        // 位置情報取得のためのデリゲート
        locationRepository.delegate = self
        locationRepository.startUpdatingLocation()
        
        let sunnyAlarm = alarmRepository.getAlarm(weatherCondition: Weather.Condition.sunny)
        let rainyAlarm = alarmRepository.getAlarm(weatherCondition: Weather.Condition.rainy)
        sunnyAlarmTime.text = AlarmUseCase.getAlarmTimeAsString(alarm: sunnyAlarm!)
        rainyAlarmTime.text = AlarmUseCase.getAlarmTimeAsString(alarm: rainyAlarm!)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(observeAlarmTimer), userInfo: nil, repeats: true)
    }
    
    func setLatitudeAndLongitude() {
        let currentLocation = LocationRepository.sharedInstance.currentLocation!

        // horizontalAccuracy（水平方向の位置の精度）がマイナスの場合は有効な値でないので切り捨てる
        if currentLocation.horizontalAccuracy > 0 {
            print("latitude: \(currentLocation.coordinate.latitude), longitude: \(currentLocation.coordinate.longitude)")
            latitude = String(currentLocation.coordinate.latitude)
            longitude = String(currentLocation.coordinate.longitude)

            // 位置情報が取得できたら取得をやめる、電池消耗防止
            locationRepository.stopUpdatingLocation()
            locationRepository.delegate = nil
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 別画面に遷移する時にはtimerを破棄しておく
        timer?.invalidate()
        AlarmUseCase.stopAlarm()
    }
    
    @objc private func observeAlarmTimer() {
        print("timer ticked: \(Date())")

        // 鳴らし終わっているアラームがあるなら処理しない
        if (alarmRepository.containsAlarms(status: Alarm.Status.rang)) {
            return
        }
        
        // 時間のきたアラームがないなら処理終了
        alarmRepository.updateAllAlarmStatus()
        let timeComingAlarm = alarmRepository.getTimeComingWeatherAlarm()
        if (timeComingAlarm == nil) {
            return
        }
        let targetWeather = timeComingAlarm!.weather
        let targetAlarm = timeComingAlarm!.alarm
        
        let geoLocation = GeoLocation()
        geoLocation.latitude = latitude
        geoLocation.longitude = longitude

        var weather = Weather()
        var weatherCondition = Weather.Condition.unsure
        // 通信可能な場合のみ天気情報を取得する。ネット未接続なら時間が来たアラームを鳴らす。
        if NetworkChecker.reachable() {
            weather = self.weatherApiClient.getWeather(geoLocation: geoLocation)
            weatherCondition = WeatherUseCase.getWeatherCondition(weatherId: weather.id)
        }

        var alarmed = false;
        // 以下の場合は強制的に時間のきたアラームを鳴らす
        // - 天気がわからない場合
        // - 他にwaitingなアラームがない（今鳴らそうとしているアラームが最後の1つ）の場合
        if weatherCondition == Weather.Condition.unsure || !alarmRepository.containsAlarms(status: Alarm.Status.waiting) {
            AlarmUseCase.ringAlarmForcibly(alarm: targetAlarm)
            alarmed = true
            print("'\(targetWeather.rawValue)' alarming forcibly...")
        }
        // 上記以外なら天気が一致する場合のみ鳴らす
        else {
            alarmed = AlarmUseCase.ringAlarm(alarm: targetAlarm, currentWeather: weatherCondition, targetWeather: targetWeather)
        }
        
        // アラームが鳴った場合
        if (alarmed) {
            print("'\(targetWeather.rawValue)' alarmed.")
            self.stopAlarmButton.isHidden = false
            self.alarmingView.isHidden = false
            self.alarmingWeather.text = WeatherUseCase.getWeatherText(weatherCondition: targetWeather)
            
            let color = WeatherUseCase.getWeatherTextColor(weatherCondition: targetWeather)
            self.alarmingWeather.textColor = UIColor(red: CGFloat(color.red)/255, green: CGFloat(color.green)/255, blue: CGFloat(color.blue)/255, alpha: 1)
            
            alarmingTime.text = AlarmUseCase.getAlarmTimeAsString(alarm: targetAlarm)
            
            // 地名表示いる？
            alarmingLocation.text = weatherCondition == Weather.Condition.unsure ? "" : weather.place!
            
            //スヌーズONの場合はもう一度カウント
            if(configRepository.getSnoozeOn()) {
                self.snoozeAlarmButton.isHidden = false
                self.snoozeAlarmButton.isEnabled = true
                self.snoozeAlarmButton.setTitle("SNOOZE", for: .normal)
                alarmRepository.snoozeAllAlarms(addSeconds: 300)
            }
        } else {
            print("'\(targetWeather.rawValue)' misfired.")
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
