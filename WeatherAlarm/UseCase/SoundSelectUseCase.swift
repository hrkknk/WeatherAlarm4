//
//  SoundSelectUseCase.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/07/07.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class SoundSelectUseCase {
    private var alarmRepository: AlarmRepositoryProtocol
    private var cacheDataAccessor: CacheDataAccessorProtocol
    private var soundRepository: SoundRepositoryProtocol
    private var soundPlayer: SoundPlayerProtocol
    
    init(alarmRepository: AlarmRepositoryProtocol,
         cacheDataAccessor: CacheDataAccessorProtocol,
         soundRepository: SoundRepositoryProtocol,
         soundPlayer: SoundPlayerProtocol){
        self.alarmRepository = alarmRepository
        self.cacheDataAccessor = cacheDataAccessor
        self.soundRepository = soundRepository
        self.soundPlayer = soundPlayer
    }
    
    func getAvailableSoundNames() -> [String] {
        return soundRepository.getSoundFileNames()
    }
    
    func getSoundNameByIndex(index: Int) -> String {
        return soundRepository.getSoundFileName(index: index)
    }
    
    func playSoundByIndex(index: Int) {
        let soundFileName = soundRepository.getSoundFileName(index: index)
        soundPlayer.playSound(fileName: soundFileName)
    }
    
    func stopSound() {
        soundPlayer.stop()
    }
    
    func setSound(weather: Weather.Condition, index: Int) {
        let alarm = alarmRepository.getAlarm(weather: weather)
        alarm.soundFileName = soundRepository.getSoundFileName(index: index)
        alarmRepository.setAlarm(weather: weather, alarm: alarm)
        cacheDataAccessor.saveAlarm(weather: weather, alarm: alarm)
    }
}
