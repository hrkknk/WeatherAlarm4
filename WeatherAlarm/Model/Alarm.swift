//
//  Alarm.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2018/10/06.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit
import os.log
import AVFoundation

class Alarm: NSObject, NSCoding {
    
    //MARK: - Properties
    var sunnyAlarmTime: Date
    var rainyAlarmTime: Date
    var sound: String
    
    var audioPlayer: AVAudioPlayer!
    
    //MARK: - Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("alarm")
    
    
    //MARK: - Types
    struct PropertyKey {
        static let sunnyAlarmTime = "sunnyAlarmTime"
        static let rainyAlarmTime = "rainyAlarmTime"
    }
    
    
    //MARK: Initialization
    init?(sunnyAlarmTime: Date, rainyAlarmTime: Date, sound: String) {
        self.sunnyAlarmTime = sunnyAlarmTime
        self.rainyAlarmTime = rainyAlarmTime
        self.sound = sound
    }
    
    
    //MARK: - Public methods
    public func getSunnyAlarmTimeAsString() -> String {
        // 日付のフォーマッタ
        let dateFormatter = DateFormatter()
        // 日付の出力形式を決める
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        // TODO: localeはあとで変更
        dateFormatter.locale = Locale(identifier: "ja_JP")
        
        return dateFormatter.string(from: sunnyAlarmTime)
    }
    
    func getRainyAlarmTimeAsString() -> String {
        // 日付のフォーマッタ
        let dateFormatter = DateFormatter()
        // 日付の出力形式を決める
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        // TODO: localeはあとで変更
        dateFormatter.locale = Locale(identifier: "ja_JP")
        
        return dateFormatter.string(from: rainyAlarmTime)
    }
    
    func playSound(){
        //パスのURL
        let sound:URL = URL(fileURLWithPath: self.sound)
        
        do {
            //AVAudioPlayerを作成
            audioPlayer = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("Could not load file")
        }
        //再生
        audioPlayer.play()
    }
    
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sunnyAlarmTime, forKey: PropertyKey.sunnyAlarmTime)
        aCoder.encode(rainyAlarmTime, forKey: PropertyKey.rainyAlarmTime)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let sunnyAlarmTime = aDecoder.decodeObject(forKey: PropertyKey.sunnyAlarmTime) as? Date else {
            os_log("Unable to decode the time for a Alarm object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let rainyAlarmTime = aDecoder.decodeObject(forKey: PropertyKey.rainyAlarmTime) as? Date else {
            os_log("Unable to decode the time for a Alarm object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        // TODO: サウンドファイル名を変数化する。ひとまず動かすために直指定。
        self.init(sunnyAlarmTime: sunnyAlarmTime, rainyAlarmTime: rainyAlarmTime, sound: Bundle.main.path(forResource: "学校のチャイム01", ofType: "mp3")!)
    }
}
