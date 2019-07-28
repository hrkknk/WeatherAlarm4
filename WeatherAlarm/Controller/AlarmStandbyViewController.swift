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
    
    //MARK: - Properties
    private let alarmStandbyUseCase: AlarmStandbyUseCase
        = AlarmStandbyUseCase(alarmRepository: AlarmRepository.sharedInstance,
                              soundPlayer: SoundPlayer.sharedInstance,
                              networkChecker: NetworkChecker.sharedInstance,
                              weatherDataAccessor: WeatherApiClient.sharedInstance,
                              locationRepository: LocationRepository.sharedInstance)
    
    private let configRepository = ConfigRepository.sharedInstance
    private var timer: Timer?

    //MARK: - Outlets
    @IBOutlet weak var sunnyAlarmTime: UILabel!
    @IBOutlet weak var rainyAlarmTime: UILabel!
    @IBOutlet weak var snoozeAlarmButton: UIButton!
    @IBOutlet weak var stopAlarmButton: UIButton!
    @IBOutlet weak var currentHourLabel: UILabel!
    @IBOutlet weak var currentColonLabel: UILabel!
    @IBOutlet weak var currentMinuteLabel: UILabel!
    @IBOutlet weak var alarmingImageView: UIImageView!
    
    //MARK: - Actions
    @IBAction func backToPrevious(_ sender: UIBarButtonItem) {
        timer?.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func snoozeAlarm(_ sender: UIButton) {
        alarmStandbyUseCase.stopAlarmSound()
        //アラーム待機画面のまま、ボタンを非活性→活性にしつつ表示を変更するだけ
        self.snoozeAlarmButton.isEnabled = false
        self.snoozeAlarmButton.setTitle("SNOOZING", for: .normal)
    }
    
    @IBAction func stopAlarm(_ sender: UIButton) {
        alarmStandbyUseCase.stopAlarmSound()
        //前画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewDidLoad()でhiddenにしているので最初は押せない
        //observeAlarmTimer()でアラームが鳴った時にhidden解除
        self.stopAlarmButton.isHidden = true
        self.snoozeAlarmButton.isHidden = true
        
        //天気アイコンをでかく表示するimage view
        //最初は非表示にしておく
        alarmingImageView.isHidden = true
        
        //現在時刻を表示
        setCurrentTimeLabels(date: Date())
        
        //設定したアラーム時刻を表示
        sunnyAlarmTime.text = alarmStandbyUseCase.getAlarmTimeAsString(weather: Weather.Condition.sunny)
        rainyAlarmTime.text = alarmStandbyUseCase.getAlarmTimeAsString(weather: Weather.Condition.rainy)
        
        //スタンバイ開始処理してタイマを起動
        alarmStandbyUseCase.startStandby()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(observeAlarmTimer), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //別画面に遷移する時にはtimerを破棄しておく
        timer?.invalidate()
        //画面が戻った後も音が鳴り続けているとダサいので停止しておく
        alarmStandbyUseCase.stopAlarmSound()
    }
    
    @objc private func observeAlarmTimer() {
        let nowDate = Date()
        setCurrentTimeLabels(date: nowDate)
        
        var isAlarmed = false
        var alarmedWeather: Weather.Condition? = nil
        
        for weather in Weather.Condition.allCases {
            if alarmStandbyUseCase.tryRingAlarm(weather: weather, time: nowDate) {
                isAlarmed = true
                alarmedWeather = weather
                break;
            }
        }
        
        //アラームが鳴らされた場合
        if (isAlarmed && alarmedWeather != nil) {
            print("'\(alarmedWeather!.rawValue)' alarmed.")
            //スタンバイ停止
            alarmStandbyUseCase.stopStandby()
            //アラームが鳴ったとき用のviewを表示
            if alarmedWeather! == Weather.Condition.rainy {
                self.alarmingImageView.image = UIImage(named: "rainy.png")
            } else {
                self.alarmingImageView.image = UIImage(named: "notrainy.png")
            }
            self.alarmingImageView.isHidden = false
            self.stopAlarmButton.isHidden = false
            //スヌーズONの場合
            if(configRepository.getConfig().isSnoozeOn) {
                self.snoozeAlarmButton.isHidden = false
                self.snoozeAlarmButton.isEnabled = true
                self.snoozeAlarmButton.setTitle("SNOOZE", for: .normal)
                alarmStandbyUseCase.snoozeAlarm(weather: alarmedWeather!,
                                                nextTime: nowDate.addingTimeInterval(Double(300)))
            }
            
            //天気に応じて文字色を変更
            let color = getWeatherTextColor(weather: alarmedWeather!)
            
            //アラームが鳴った時刻を表示
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
        }
    }
    
    private func getWeatherText(weather: Weather.Condition?) -> String {
        if weather == nil {
            return "Unsure"
        }
        
        switch (weather!) {
        case Weather.Condition.sunny:
            return "Sunny"
        case Weather.Condition.rainy:
            return "Rainy"
        default:
            return "Unsure"
        }
    }
    
    private func getWeatherTextColor(weather: Weather.Condition) -> (red: Int, green: Int, blue: Int) {
        switch (weather) {
        case Weather.Condition.sunny:
            return (255, 181, 30)
        case Weather.Condition.rainy:
            return (10, 132, 255)
        default:
            return (255, 255, 255)
        }
    }
    
    private func setCurrentTimeLabels(date: Date) {
        let nowHour = Calendar.current.component(.hour, from: date)
        let nowMinute = Calendar.current.component(.minute, from: date)
        let nowSecond = Calendar.current.component(.second, from: date)
        
        currentHourLabel.text = "\(nowHour)"
        currentMinuteLabel.text = String(format: "%02d", nowMinute)
        
        if nowSecond % 2 == 0 {
            currentColonLabel.isHidden = true
        } else {
            currentColonLabel.isHidden = false
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
