//
//  UserDefaultsManager.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-10-02.
//

import Foundation

class UserDefaultsManager {
    
    static let defaults = UserDefaults.standard
    static let alarmGroupKey = "AlarmGroup"
    
    private init() {}
    
    /// UserDefaults에 특정 객체를 저장하는 메서드
    static func save<T>(_ object: T, forKey key: String) where T: Codable {
        var existingObject: [T] = load(forKey: key)
        existingObject.append(object)
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(existingObject) {
            defaults.set(data, forKey: key)
        } else {
            print("UserDefaultsManager: 저장하는 것을 실패했습니다.")
        }
    }
    /// UserDefaults에 저장되어 있는 특정 객체를 불러오는 메서드
    static func load<T>(forKey key: String) -> [T] where T: Codable {
        guard let data = defaults.data(forKey: key) else { return [] }
        
        let decoder = JSONDecoder()
        if let data = try? decoder.decode([T].self, from: data) {
            return data
        } else {
            return []
        }
    }
    
    static func updateAlarm(_ updatedObject: Alarm, forKey key: String) {
        var existingObject: [Alarm] = load(forKey: key)
        
        if let index = existingObject.firstIndex(where: { $0.uuid == updatedObject.uuid }) {
            existingObject[index] = updatedObject
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(existingObject) {
                defaults.set(data, forKey: key)
            } else {
                print("UserDefaultsManager : 업데이트를 실패했습니다.")
            }
        }
    }
    
    static func deleteAlarm(at index: Int, forKey key: String) {
        var existingObject: [Alarm] = load(forKey: key)
        
        if index >= 0 && index < existingObject.count {
            existingObject.remove(at: index)
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(existingObject) {
                defaults.set(data, forKey: key)
            } else {
                print("UserDefaultsManager : 알람을 삭제하는 것을 실패했습니다.")
            }
        }
    }

    
    static func printAlarmGroup() {
        let alarms: [Alarm] = load(forKey: alarmGroupKey)
        for alarm in alarms {
            print("Alarm: \(alarm.label), Time: \(alarm.hour):\(alarm.minute)")
        }
    }
    
    static func resetUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
}
