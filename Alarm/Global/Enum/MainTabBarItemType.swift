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
        case .weather: return "circle"
        case .alarm: return "circle"
        case .stopwatch: return "circle"
        case .timer: return "circle"
        }
    }
    
    func getCoordinator(navigationController: UINavigationController) -> Coordinator {
        switch self {
        case .weather: return WeatherViewCoordinator(navigationController: navigationController)
        case .alarm: return AlarmViewCoordinator(navigationController: navigationController)
        case .stopwatch: return StopwatchViewCoordinator(navigationController: navigationController)
        case .timer: return TimerViewCoordinator(navigationController: navigationController)
        }
    }
    
}
