//
//  AlarmStandbyUseCase.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/06/27.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class AlarmStandbyUseCase {
    private var alarmRepository: AlarmRepositoryProtocol
    private var soundPlayer: SoundPlayerProtocol
    private var networkChecker: NetworkCheckerProtocol
    private var weatherDataAccessor: WeatherDataAccessorProtocol
    private var locationRepository: LocationRepositoryProtocol
    
    init(alarmRepository: AlarmRepositoryProtocol,
         soundPlayer: SoundPlayerProtocol,
         networkChecker: NetworkCheckerProtocol,
         weatherDataAccessor: WeatherDataAccessorProtocol,
         locationRepository: LocationRepositoryProtocol) {
        self.alarmRepository = alarmRepository
        self.soundPlayer = soundPlayer
        self.networkChecker = networkChecker
        self.weatherDataAccessor = weatherDataAccessor
        self.locationRepository = locationRepository
    }
    
    func startStandby(){
        //フラグ系を全てリセット
        for weather in Weather.Condition.allCases {
            let alarm = alarmRepository.getAlarm(weather: weather)
            alarm.isTried = false
            alarm.isRang = false
            alarmRepository.setAlarm(weather: weather, alarm: alarm)
        }
        locationRepository.startUpdatingLocation()
    }
    
    func stopStandby(){
        locationRepository.stopUpdatingLocation()
    }
    
    func getAlarmTimeAsString(weather: Weather.Condition) -> String {
        return alarmRepository.getAlarm(weather: weather).getTimeAsString()
    }
    
    func stopAlarmSound() {
        soundPlayer.stop()
    }
    
    func snoozeAlarm(weather: Weather.Condition, nextTime: Date) {
        let alarm = alarmRepository.getAlarm(weather: weather)
        alarm.setTime(dateTime: nextTime)
        alarm.isTried = false
        alarm.isRang = false
        alarmRepository.setAlarm(weather: weather, alarm: alarm)
        locationRepository.startUpdatingLocation()
    }
    
    func tryRingAlarm(weather: Weather.Condition, time: Date) -> Bool {
        let alarm = alarmRepository.getAlarm(weather: weather)
        
        //すでにトライ済みの場合は処理しない
        if alarm.isTried {
            return false
        }
        
        //アラーム設定された時刻でない場合は処理しない
        if !alarm.isRingTime(dateTime: time) {
            return false
        }
        
        //既に鳴らされたアラームがあるなら処理しない
        if alarmRepository.getRangAlarms().count > 0 {
            return false
        }
        
        //トライされていない最後のアラームであるかどうか
        let isLastOne = alarmRepository.getNotTriedAlarms().count == 1
        //トライ済みにする（isLastOneを正しく判定するため↑の後に処理する必要がある）
        alarm.isTried = true
        alarmRepository.setAlarm(weather: weather, alarm: alarm)
        
        //トライされていない最後のアラームである場合は天気無関係に鳴らす
        if isLastOne {
            print("'\(weather.rawValue)' alarming because last one.")
            ringAlarm(weather: weather, alarm: alarm)
            return true
        }
        
        //通信できない場合は天気情報が取得できないので、トライ中のアラームを鳴らす
        if !networkChecker.checkAvailable() {
            print("'\(weather.rawValue)' alarming because network unavailable.")
            ringAlarm(weather: weather, alarm: alarm)
            return true
        }
        
        //天気情報取得のためには位置情報が必要なのでその取得
        let location = locationRepository.getLocation()
        if location == nil || location?.latitude == nil || location?.longitude == nil {
            print("'\(weather.rawValue)' alarming because location unknown.")
            ringAlarm(weather: weather, alarm: alarm)
            return true
        }
        
        //天気情報取得
        let weatherData = weatherDataAccessor.getWeather(geoLocation: location!)
        
        // 天気が一致する場合は鳴らす
        if weatherData.condition == weather {
            ringAlarm(weather: weather, alarm: alarm)
            return true
        }
        return false
    }
    
    private func ringAlarm(weather: Weather.Condition, alarm: Alarm) {
        soundPlayer.playAlarmSound(alarm: alarm)
        alarm.isRang = true
        alarmRepository.setAlarm(weather: weather, alarm: alarm)
    }
}
