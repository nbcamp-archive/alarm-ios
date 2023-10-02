//
//  UserDefaultsManager.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-10-02.
//

import Foundation

class UserDefaultsManager {
    
    static let defaults = UserDefaults.standard
    
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
    
}
