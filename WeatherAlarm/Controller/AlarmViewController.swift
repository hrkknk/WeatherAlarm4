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

    // MARK: - Properties
    var alarm: Alarm?

    
    //MARK: - Outlets
    @IBOutlet weak var sunnyAlarmDatePicker: UIDatePicker!
    @IBOutlet weak var rainyAlarmDatePicker: UIDatePicker!

    
    //MARK: - Actions
    @IBAction func setAlarm(_ sender: UIButton) {
        saveAlarm()
    }
    
    @IBAction func setSunnyAlarm(_ sender: UIDatePicker) {
        alarm!.sunnyAlarmTime = sender.date
    }
    
    @IBAction func setRainyAlarm(_ sender: UIDatePicker) {
        alarm!.rainyAlarmTime = sender.date
    }
    
    
    //MARK: - Methods
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //保存データがある場合、それを読み込む
        alarm = loadAlarm()
        
        //時刻引き継ぎ
        if let alarm = alarm {
            self.sunnyAlarmDatePicker.date = alarm.sunnyAlarmTime
            self.rainyAlarmDatePicker.date = alarm.rainyAlarmTime
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
        
        switch(segue.identifier ?? "") {
            //セグエがAlarmStandbyだったら画面遷移の準備処理を行う
            case "AlarmStandby":
                //UINavigationControllerを取得
                guard let navigationController = segue.destination as? UINavigationController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                //UINavigationControllerの次の画面(AlarmStandbyViewController)を取得
                guard let alarmStandbyViewController = navigationController.topViewController as? AlarmStandbyViewController else {
                    fatalError("Unexpected topViewController: \(String(describing: navigationController.topViewController))")
                }
                //次の画面(AlarmStandbyViewController)へalarmを受け渡し
                alarmStandbyViewController.alarm = self.alarm
            
            //TODO: サウンド選択画面に遷移
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    private func saveAlarm() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(alarm, toFile: Alarm.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Alarm successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save alarm...", log: OSLog.default, type: .error)
        }
    }

    private func loadAlarm() -> Alarm?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Alarm.ArchiveURL.path) as? Alarm
    }
}

