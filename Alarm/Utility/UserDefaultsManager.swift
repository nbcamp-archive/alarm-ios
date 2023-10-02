//
//  UserDefaultsManager.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-10-02.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    static func save<T: Codable>(_ object: [T], forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {
            UserDefaults.standard.set(data, forKey: key)
        } else {
            print("UserDefaultsManager: 저장하는 것을 실패했습니다.")
        }
    }
    
    static func load<T: Codable>(forKey key: String) -> [T] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [T]() }
        
        let decoder = JSONDecoder()
        if let data = try? decoder.decode([T].self, from: data) {
            return data
        } else {
            return [T]()
        }
    }
    
}
