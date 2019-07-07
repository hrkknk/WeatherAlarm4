//
//  SoundRepository.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/07/07.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

class SoundRepository: SoundRepositoryProtocol {
    static let sharedInstance: SoundRepository = SoundRepository()
    private var soundFileNames: [String] = ["学校のチャイム01",
                                            "シングル・ワルツ06"]
    
    private init() {}
    
    func getSoundFileNames() -> [String] {
        return soundFileNames
    }
    
    func getSoundFileName(index: Int) -> String {
        return soundFileNames[index]
    }
}
