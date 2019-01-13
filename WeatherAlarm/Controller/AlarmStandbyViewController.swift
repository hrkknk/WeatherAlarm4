//
//  AlarmStandbyViewController.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2019/01/04.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import UIKit

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
        //前の画面(AlarmViewController)のprepare()で渡してもらったalarmから時刻を抽出
        sunnyAlarmTime.text = self.alarm?.getSunnyAlarmTimeAsString()
        rainyAlarmTime.text = self.alarm?.getRainyAlarmTimeAsString()
        
        //アラームを鳴らす時刻までの秒数を取得
        self.secondsForSunnyAlarm = calculateInterval(userAwakeTime: (self.alarm?.sunnyAlarmTime)!)
        self.secondsForRainyAlarm = calculateInterval(userAwakeTime: (self.alarm?.rainyAlarmTime)!)
        
        //更新用の変数を用意
        self.remainForSunnyAlarm = self.secondsForSunnyAlarm
        self.remainForRainyAlarm = self.secondsForRainyAlarm
        
        if timer == nil{
            //タイマーをセット、一秒ごとにupdateCurrentTimeを呼ぶ
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func updateCurrentTime() {
        if(!isRungAlarm && self.remainForSunnyAlarm <= 0) {
            //TODO: Sunnyアラーム鳴らす判定
            print("Sunny: \(remainForSunnyAlarm)")
            self.alarm?.playSound()
            isRungAlarm = true
        } else {
            self.remainForSunnyAlarm -= 1
        }
        
        if(!isRungAlarm && self.remainForRainyAlarm <= 0) {
            //TODO: Rainyアラーム鳴らす判定
            print("Rainy: \(remainForRainyAlarm)")
            self.alarm?.playSound()
            isRungAlarm = true
        } else {
            self.remainForRainyAlarm -= 1
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
