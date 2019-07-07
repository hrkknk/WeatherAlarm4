//
//  SoundSelectUseCase.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/07/07.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class SoundSelectUseCase {
    private var soundRepository: SoundRepositoryProtocol
    private var soundPlayer: SoundPlayerProtocol
    
    init(soundRepository: SoundRepositoryProtocol,
         soundPlayer: SoundPlayerProtocol){
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
}
