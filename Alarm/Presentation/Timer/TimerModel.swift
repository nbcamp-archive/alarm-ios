//
//  TimerModel.swift
//  Alarm
//
//  Created by 이재희 on 2023/09/27.
//

import UIKit
import UserNotifications

extension Notification.Name {
    static let timerValueChanged = Notification.Name("TimerValueChanged")
    static let timerStopped = Notification.Name("TimerStopped")
}

final class TimerModel: NSObject {
    
    //MARK: - Constants
    
    public enum State {
        case running
        case paused
        case `default`
    }
    
    private enum PropertySaveKeys {
        static let state = "Timer_State"
        static let initialTime = "Timer_InitialTime"
        static let alarmSound = "Timer_AlarmSound"
        static let alarmSoundFile = "Timer_AlarmSoundFile"
    }
    
    //MARK: - Properties
    
    private(set) var state: State = .default
    private(set) var initialTime: TimeInterval = 0
    private(set) var alarmSound: String?
    private(set) var alarmSoundFile: String?
    private var timer: Timer?
    private var backgroundTime: TimeInterval = 0
    private(set) var endTime: Date?
    
    
    //MARK: - Life Cycle
    
    override init(){
        super.init()
        
        setup()
        
        if alarmSound == nil {
            alarmSound = "전파 탐지기(기본 설정)"
            alarmSoundFile = "default.caf"
            UserDefaults.standard.set(alarmSound, forKey: PropertySaveKeys.alarmSound)
            UserDefaults.standard.set(alarmSoundFile, forKey: PropertySaveKeys.alarmSoundFile)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: - UserNotifications
    
    private func scheduleNotificationForEndTime(endTime: Date) {
        let timeInterval = endTime.timeIntervalSinceNow
        
        if timeInterval > 0 {
            let content = UNMutableNotificationContent()
            content.title = "시계"
            content.body = "타이머"
            
            alarmSound = UserDefaults.standard.string(forKey: "Timer_AlarmSound")
            alarmSoundFile = UserDefaults.standard.string(forKey: "Timer_AlarmSoundFile")
            content.sound = UNNotificationSound(named: UNNotificationSoundName((alarmSoundFile)!))
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: "timerNotification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("알림 예약 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func cancelNotificationForOldEndTime() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["timerNotification"])
    }
    
    private func updateNotificationForNewEndTime() {
        cancelNotificationForOldEndTime()
        if let endTime = self.endTime {
            scheduleNotificationForEndTime(endTime: endTime)
        }
    }
    
    //MARK: - Timer Control
    
    private func calculateEndTime(from initialTime: TimeInterval) -> Date {
        let currentDate = Date()
        let endTime = currentDate.addingTimeInterval(initialTime)
        return endTime
    }
    
    func start(withInitialTime initialTime: TimeInterval) {
        guard state != .running else {
            return
        }
        
        self.initialTime = initialTime
        
        state = .running
        
        endTime = calculateEndTime(from: initialTime)
        scheduleNotificationForEndTime(endTime: endTime!)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        NotificationCenter.default.post(name: .timerValueChanged, object: self)
    }
    
    func pause() {
        guard state == .running else {
            return
        }
        
        timer?.invalidate()
        state = .paused
        
        cancelNotificationForOldEndTime()
    }
    
    func resume() {
        guard state == .paused else {
            return
        }
        
        state = .running
        
        if initialTime > 0 {
            endTime = calculateEndTime(from: initialTime)
            updateNotificationForNewEndTime()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        state = .default
        
        if initialTime > 0 {
            cancelNotificationForOldEndTime()
        }
        NotificationCenter.default.post(name: .timerStopped, object: self)
        print("---------------timer stopped---------------")
    }
    
    @objc private func updateTimer() {
        if initialTime <= 0 {
            stop()
            //NotificationCenter.default.post(name: .timerStopped, object: self)
        } else {
            initialTime -= 1
            NotificationCenter.default.post(name: .timerValueChanged, object: self)
        }
    }
    
    @objc private func appWillEnterForeground() {
        if state == .running {
            let elapsedTimeInBackground = Date().timeIntervalSinceReferenceDate - backgroundTime
            initialTime -= elapsedTimeInBackground
            if initialTime <= 0 {
                initialTime = 0
                stop()
            } else {
                endTime = calculateEndTime(from: initialTime)
                NotificationCenter.default.post(name: .timerValueChanged, object: self)
            }
        }
    }
    
    //MARK: - UserDefaults
    
    private func setup(){
        if let savedState = UserDefaults.standard.value(forKey: PropertySaveKeys.state) as? String,
           let savedInitialTime = UserDefaults.standard.value(forKey: PropertySaveKeys.initialTime) as? TimeInterval,
           let savedAlarmSound = UserDefaults.standard.value(forKey: PropertySaveKeys.alarmSound) as? String, let savedAlarmSoundFile = UserDefaults.standard.value(forKey: PropertySaveKeys.alarmSoundFile) as? String {
            
            state = savedState == "running" ? .running : .default
            initialTime = savedInitialTime
            alarmSound = savedAlarmSound
            alarmSoundFile = savedAlarmSoundFile
        }
    }
    
    @objc private func save(){
        UserDefaults.standard.set(state == .running ? "running" : "stopped", forKey: PropertySaveKeys.state)
        UserDefaults.standard.set(initialTime, forKey: PropertySaveKeys.initialTime)
        //UserDefaults.standard.set(alarmSound, forKey: PropertySaveKeys.alarmSound)
        //UserDefaults.standard.set(alarmSoundFile, forKey: PropertySaveKeys.alarmSoundFile)
        
        backgroundTime = Date().timeIntervalSinceReferenceDate
    }
}
