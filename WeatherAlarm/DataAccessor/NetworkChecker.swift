//
//  NetworkChecker.swift
//  WeatherAlarm
//
//  Created by Kunihisa Fujiwara on 2019/04/14.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import Reachability

class NetworkChecker {
    static func reachable() -> Bool {
        if let reachability = Reachability() {
            print("Reachability.connection : \(reachability.connection)")
            return reachability.connection != .none
        }
        return false
    }
}
