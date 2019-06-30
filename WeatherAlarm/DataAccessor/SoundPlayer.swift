//
//  SoundPlayer.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/06/27.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer: SoundPlayerProtocol {
    static let sharedInstance: SoundPlayer = SoundPlayer()
    
    //AVAudioPlayerはプロパティとして保持しておかないと動かないらしい
    private var player: AVAudioPlayer?
    
    private init() { }
    
    func playAlarmSound(alarm: Alarm) {
        let soundFilePath = Bundle.main.path(forResource: alarm.soundFileName!, ofType: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFilePath), fileTypeHint:nil)
            player?.play()
        } catch {
            print("Failed to create alarm; \(error)")
        }
    }
    
    func stop() {
        self.player?.stop()
    }
}
