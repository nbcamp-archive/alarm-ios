//
//  MainTabBarItemType.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

enum MainTabBarItemType: String, CaseIterable {
    
    case weather, alarm, stopwatch, timer
    
    init?(index: Int) {
        switch index {
        case 0: self = .weather
        case 1: self = .alarm
        case 2: self = .stopwatch
        case 3: self = .timer
        default: return nil
        }
    }
    
    func toInt() -> Int {
        switch self {
        case .weather: return 0
        case .alarm: return 1
        case .stopwatch: return 2
        case .timer: return 3
        }
    }
    
    func toSymbolName() -> String {
        switch self {
        case .weather: return "날씨"
        case .alarm: return "알람"
        case .stopwatch: return "스톱워치"
        case .timer: return "타이머"
        }
    }
    
    func toSymbol() -> String {
        switch self {
        case .weather: return "cloud.sun.fill"
        case .alarm: return "alarm.fill"
        case .stopwatch: return "stopwatch.fill"
        case .timer: return "timer"
        }
    }
    
}
