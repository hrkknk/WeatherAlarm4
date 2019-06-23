//
//  AlarmViewController.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2018/08/12.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit
import CoreLocation

class AlarmViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var sunnyAlarmDatePicker: UIDatePicker!
    @IBOutlet weak var rainyAlarmDatePicker: UIDatePicker!
    @IBOutlet weak var selectedSoundName: UILabel!
    
    private let alarmRepository: AlarmRepository = AlarmRepository.sharedInstance
    private let configRepository: ConfigRepository = ConfigRepository.sharedInstance

    @IBAction func setSunnyAlarm(_ sender: UIDatePicker) {
        let alarm = AlarmUseCase.createAlarm(date: sender.date)
        alarmRepository.setAlarm(weatherCondition: Weather.Condition.sunny, alarm: alarm)
    }
    
    @IBAction func setRainyAlarm(_ sender: UIDatePicker) {
        let alarm = AlarmUseCase.createAlarm(date: sender.date)
        alarmRepository.setAlarm(weatherCondition: Weather.Condition.rainy, alarm: alarm)
    }
    
    @IBAction func changeSnoozeOnOff(_ sender: UISwitch) {
        configRepository.setSnoozeOn(isSnoozeOn: sender.isOn)
    }
    
    @IBAction func standbyAlarm(_ sender: UIButton) {
        let locationStatus = CLLocationManager.authorizationStatus()
        if locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse {
            print("location status: authorized always or authorized when in use")
            performSegue(withIdentifier: "AlarmStandby", sender: nil)
        } else {
            print("location status: denied or restricted")
            performSegue(withIdentifier: "LocationAgreement", sender: nil)
        }
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        //ブラックUI化
        view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        self.sunnyAlarmDatePicker.setValue(UIColor.white, forKey: "textColor")
        self.rainyAlarmDatePicker.setValue(UIColor.white, forKey: "textColor")
        
        //前回保存したデータのロード
        alarmRepository.loadAlarm(weatherCondition: Weather.Condition.sunny)
        alarmRepository.loadAlarm(weatherCondition: Weather.Condition.rainy)

        initAlarmDatePickers()
    }
    
    private func initAlarmDatePickers() {
        if let sunnyAlarm = alarmRepository.getAlarm(weatherCondition: Weather.Condition.sunny) {
            self.sunnyAlarmDatePicker.date = AlarmUseCase.getAlarmTimeAsDate(alarm: sunnyAlarm)
        } else {
            self.sunnyAlarmDatePicker.date = Date()
        }
        
        if let rainyAlarm = alarmRepository.getAlarm(weatherCondition: Weather.Condition.rainy) {
            self.rainyAlarmDatePicker.date = AlarmUseCase.getAlarmTimeAsDate(alarm: rainyAlarm)
        } else {
            self.rainyAlarmDatePicker.date = Date()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //TODO: サウンド選択画面に遷移
    }
}

