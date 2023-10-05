//
//  Alarm.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-10-02.
//

import Foundation

class Alarm: Codable {
    
    let uuid: UUID
    
    var hour: String
    var minute: String
    var dayOfWeekdays: [Int]
    var label: String
    var tone: Tone
    var isEnabled: Bool
    var isSnoozeEnabled: Bool

    
    init(uuid: UUID, hour: String, minute: String, dayOfWeekdays: [Int],
         label: String, tone: Tone, isEnabled: Bool, isSnoozeEnabled: Bool) {
        self.uuid = uuid
        self.hour = hour
        self.minute = minute
        self.dayOfWeekdays = dayOfWeekdays
        self.label = label
        self.tone = tone
        self.isEnabled = isEnabled
        self.isSnoozeEnabled = isSnoozeEnabled
    }
    
    convenience init() {
        self.init(uuid: UUID(), hour: "00", minute: "00", dayOfWeekdays: [],
                  label: "알람", tone: Tone(), isEnabled: true, isSnoozeEnabled: false)
    }
    
}
