//
//  SoundRepositoryProtocol.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/07/07.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation

protocol SoundRepositoryProtocol {
    func getSoundFileNames() -> [String]
    func getSoundFileName(index: Int) -> String
}
