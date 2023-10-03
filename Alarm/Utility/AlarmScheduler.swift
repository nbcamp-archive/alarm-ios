//
//  AlarmScheduler.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-10-03.
//

import Foundation
import UserNotifications

class AlarmScheduler {
    
    private static let notificationCenter = UNUserNotificationCenter.current()
    
    static func registAlarms() {
        notificationCenter.removeAllPendingNotificationRequests()
        
        let alarmGroup: [Alarm] = UserDefaultsManager.load(forKey: UserDefaultsManager.alarmGroupKey)
        
        for alarm in alarmGroup {
            if alarm.isEnabled {
                for dayOfWeek in alarm.dayOfWeekdays {
                    var dateComponents = DateComponents()
                    dateComponents.hour = alarm.hour
                    dateComponents.minute = alarm.minute
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    let content = UNMutableNotificationContent()
                    content.title = "알람"
                    content.body = alarm.label
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "daydreaming.caf"))
                    
                    let requestIdentifier = "\(alarm.uuid.uuidString)-\(dayOfWeek)"
                    let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
                    
                    notificationCenter.add(request) { (error) in
                        if let error = error {
                            print("알람 등록을 실패했습니다: \(error)")
                        } else {
                            print("알람이 성공적으로 예약되었습니다.")
                        }
                    }
                }
            }
        }
    }
    
    static func checkScheduledAlarms() {
        notificationCenter.getPendingNotificationRequests { (requests) in
            for request in requests {
                print(request)
            }
        }
    }
    
}
