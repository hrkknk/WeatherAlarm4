//
//  ViewController.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2018/08/12.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit
import os.log

class AlarmViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var sunnyAlarmDatePicker: UIDatePicker!
    @IBOutlet weak var rainyAlarmDatePicker: UIDatePicker!
    
    let alarmRepo: AlarmRepository = AlarmRepository.sharedInstance
    
    //MARK: - Actions
    @IBAction func setAlarm(_ sender: UIButton) {
        //TODO: saving alarms
    }
    
    @IBAction func setSunnyAlarm(_ sender: UIDatePicker) {
        let alarm = AlarmUseCase.createAlarm(date: sender.date)
        alarmRepo.setAlarm(weather: Weather.sunny, alarm: alarm)
    }
    
    @IBAction func setRainyAlarm(_ sender: UIDatePicker) {
        let alarm = AlarmUseCase.createAlarm(date: sender.date)
        alarmRepo.setAlarm(weather: Weather.rainy, alarm: alarm)
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ブラックUI化
        view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        self.sunnyAlarmDatePicker.setValue(UIColor.white, forKey: "textColor")
        self.rainyAlarmDatePicker.setValue(UIColor.white, forKey: "textColor")
        
        //TODO: load alarms
        
        initAlarmDatePickers()
    }
    
    private func initAlarmDatePickers() {
        if let sunnyAlarm = alarmRepo.getAlarm(weather: Weather.sunny) {
            self.sunnyAlarmDatePicker.date = AlarmUseCase.getAlarmDate(alarm: sunnyAlarm)
        } else {
            self.sunnyAlarmDatePicker.date = Date()
        }
        
        if let rainyAlarm = alarmRepo.getAlarm(weather: Weather.rainy) {
            self.rainyAlarmDatePicker.date = AlarmUseCase.getAlarmDate(alarm: rainyAlarm)
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

