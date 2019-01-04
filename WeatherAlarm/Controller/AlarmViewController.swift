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
        
        //TODO: データロード
        //保存データがある場合、それを読み込む
        if let savedAlarm = loadAlarm() {
            alarm = savedAlarm
        } else {
            // Load the sample data.
//            alarm += loadSampleAlarm()
        }
        //編集モードの場合、各UIの値を前画面から渡されたアラームの内容に更新
        if let alarm = alarm {
            //時刻引き継ぎ
            self.sunnyAlarmDatePicker.date = alarm.sunnyAlarmTime
            self.rainyAlarmDatePicker.date = alarm.rainyAlarmTime
            //TODO: 他のUIも初期化
        } else { //編集モードでない場合、新規アラーム追加用にalarmを初期化
            alarm = Alarm(sunnyAlarmTime: sunnyAlarmDatePicker.date, rainyAlarmTime: rainyAlarmDatePicker.date)
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
        
//        //セグエによる画面遷移ではない場合、ボタン押下処理を行う
//        if(segue.identifier == nil) {
//            guard let button = sender as? UIBarButtonItem, button === saveButton else {
//                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
//                return
//            }
//
//            //AddAlarmで遷移してきた場合は新規にアラームを生成
//            //EditAlarm遷移してきた場合はアラームを更新
//            alarm = Alarm(sunnyAlarmTime: SunnyAlarmDatePicker.date, rainyAlarmTime: RainyAlarmDatePicker.date)
//            return
//        }
        
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
                //次の画面(AlarmStandbyViewController)で表示するためのdate情報を受け渡す
                alarmStandbyViewController.sunnyAlarmTimeString = alarm?.getSunnyAlarmTimeAsString()
                alarmStandbyViewController.rainyAlarmTimeString = alarm?.getRainyAlarmTimeAsString()
            
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

