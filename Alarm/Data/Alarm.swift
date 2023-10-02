//
//  Alarm.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-10-02.
//

import Foundation

struct Tone: Codable, Equatable {
    let name: String
    let filename: String
}

class Alarm: Codable {
    
    let uuid: UUID
    
    var hour: Int
    var minute: Int
    var isEnabled: Bool
    var isSnoozeEnabled: Bool
    var dayOfWeekdays: [Int]
    var tone: Tone
    var label: String
    
    init(uuid: UUID, hour: Int, minute: Int, isEnabled: Bool, isSnoozeEnabled: Bool, dayOfWeekdays: [Int], tone: Tone, label: String) {
        self.uuid = uuid
        self.hour = hour
        self.minute = minute
        self.isEnabled = isEnabled
        self.isSnoozeEnabled = isSnoozeEnabled
        self.dayOfWeekdays = dayOfWeekdays
        self.tone = tone
        self.label = label
    }
    
    convenience init() {
        self.init(uuid: UUID(),
                  hour: 0,
                  minute: 0,
                  isEnabled: true,
                  isSnoozeEnabled: false,
                  dayOfWeekdays: [],
                  tone: Tone(name: "기본", filename: "default.mp3"),
                  label: "알람")
    }
    
}
