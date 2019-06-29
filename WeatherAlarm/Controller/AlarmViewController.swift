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
    
    //MARK: - Properties
    private let alarmSetUseCase: AlarmSetUseCse
        = AlarmSetUseCse(alarmRepository: AlarmRepository.sharedInstance,
                         configRepository: ConfigRepository.sharedInstance,
                         cacheDataAccessor: CacheDataAccessor.sharedInstance)
    
    //MARK: - Outlets
    @IBOutlet weak var sunnyAlarmDatePicker: UIDatePicker!
    @IBOutlet weak var rainyAlarmDatePicker: UIDatePicker!
    @IBOutlet weak var selectedSoundName: UILabel!
    
    @IBAction func setSunnyAlarm(_ sender: UIDatePicker) {
        alarmSetUseCase.updateAlarmTime(weather: Weather.Condition.sunny, dateTime: sender.date)
    }
    
    @IBAction func setRainyAlarm(_ sender: UIDatePicker) {
        alarmSetUseCase.updateAlarmTime(weather: Weather.Condition.rainy, dateTime: sender.date)
    }
    
    @IBAction func changeSnoozeOnOff(_ sender: UISwitch) {
        alarmSetUseCase.setSnooze(isSnoozeOn: sender.isOn)
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
        alarmSetUseCase.loadCache()
        
        //アラーム設定時刻の初期表示
        self.sunnyAlarmDatePicker.date = alarmSetUseCase.getAlarmTime(weather: Weather.Condition.sunny)
        self.sunnyAlarmDatePicker.date = alarmSetUseCase.getAlarmTime(weather: Weather.Condition.rainy)
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

