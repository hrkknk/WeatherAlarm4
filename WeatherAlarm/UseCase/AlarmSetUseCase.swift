//
//  SetAlarmUseCase.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/06/26.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class AlarmSetUseCse {
    private var alarmRepository: AlarmRepositoryProtocol
    private var configRepository: ConfigRepositoryProtocol
    private var cacheDataAccessor: CacheDataAccessorProtocol
    
    init(alarmRepository: AlarmRepositoryProtocol,
         configRepository: ConfigRepositoryProtocol,
         cacheDataAccessor: CacheDataAccessorProtocol) {
        self.alarmRepository = alarmRepository
        self.configRepository = configRepository
        self.cacheDataAccessor = cacheDataAccessor
    }
    
    func loadCache() {
        //alarms
        for weather in Weather.Condition.allCases {
            var alarm = cacheDataAccessor.loadAlarm(weather: weather)
            //キャッシュがない or ロード失敗した場合には現在時刻とデフォルト音声で alarm を生成します
            if alarm == nil {
                alarm = Alarm()
                alarm!.setTime(dateTime: Date())
                alarm!.soundFileName = "学校のチャイム01"
            }
            alarmRepository.setAlarm(weather: weather, alarm: alarm!)
        }
        //config
        var config = cacheDataAccessor.loadConfig()
        if config == nil {
            config = Config()
        }
        configRepository.setConfig(config: config!)
    }
    
    func getAlarmTime(weather: Weather.Condition) -> Date {
        let alarm = alarmRepository.getAlarm(weather: weather)
        return Calendar.current.date(from: DateComponents(hour: alarm.hour, minute: alarm.minute))!
    }
    
    func updateAlarmTime(weather: Weather.Condition, dateTime: Date) {
        let alarm = alarmRepository.getAlarm(weather: weather)
        alarm.setTime(dateTime: dateTime)
        alarmRepository.setAlarm(weather: weather, alarm: alarm)
        //アラーム時刻が更新されるたびにキャッシュも更新します
        cacheDataAccessor.saveAlarm(weather: weather, alarm: alarm)
    }
    
    func getSnooze() -> Bool {
        return configRepository.getConfig().isSnoozeOn
    }
    
    func setSnooze(isSnoozeOn: Bool) {
        let config = configRepository.getConfig()
        config.isSnoozeOn = isSnoozeOn
        configRepository.setConfig(config: config)
        //snooze設定が切り替えられるたびにキャッシュも更新します
        cacheDataAccessor.saveConfig(config: config)
    }
}
