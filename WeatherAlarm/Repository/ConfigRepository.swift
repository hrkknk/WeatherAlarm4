//
//  ConfigRepository.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2019/04/14.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Foundation
class ConfigRepository: NSObject, ConfigRepositoryProtocol {
    static let sharedInstance: ConfigRepository = ConfigRepository()
    private var config: Config
    
    private override init() {
        self.config = Config()
    }
    
    func getConfig() -> Config {
        return self.config
    }
    
    func setConfig(config: Config) {
        self.config = config
    }
}
