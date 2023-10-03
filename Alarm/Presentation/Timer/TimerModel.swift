//
//  TimerModel.swift
//  Alarm
//
//  Created by 이재희 on 2023/09/27.
//

import UIKit
import AVFoundation

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
    }
    
    //MARK: - Properties
    
    private(set) var state: State = .default
    private(set) var initialTime: TimeInterval = 0
    private(set) var alarmSound: String?
    private var timer: Timer?
    private var backgroundTime: TimeInterval = 0
    private(set) var endTime: Date?
    
    private var alarmPlayer: AVAudioPlayer?
    
    //MARK: - Life Cycle
    
    override init(){
        super.init()
        
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: - Timer Control
    
    private func calculateEndTime(from initialTime: TimeInterval) -> Date {
        let currentDate = Date()
        let endTime = currentDate.addingTimeInterval(initialTime)
        return endTime
    }
    
    func start(withInitialTime initialTime: TimeInterval, alarmSound: String?) {
        guard state != .running else {
            return
        }
        
        self.initialTime = initialTime
        self.alarmSound = alarmSound
        
        state = .running
        
        endTime = calculateEndTime(from: initialTime)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        NotificationCenter.default.post(name: .timerValueChanged, object: self)
    }
    
    func pause() {
        guard state == .running else {
            return
        }
        
        timer?.invalidate()
        state = .paused
    }
    
    func resume() {
        guard state == .paused else {
            return
        }
        
        state = .running
        
        if initialTime > 0 {
            endTime = calculateEndTime(from: initialTime)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        state = .default
        print("---------------timer stopped---------------")
    }
    
    @objc private func updateTimer() {
        if initialTime <= 0 {
            stop()
            NotificationCenter.default.post(name: .timerStopped, object: self)
            //playAlarmSound()
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
            }
        }
        NotificationCenter.default.post(name: .timerValueChanged, object: self)
    }
    
    private func playAlarmSound() {
        if let soundName = alarmSound, let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                let player = try AVAudioPlayer(contentsOf: soundURL)
                player.play()
            } catch {
                
            }
        }
    }
    
    //MARK: - UserDefaults
    
    private func setup(){
        if let savedState = UserDefaults.standard.value(forKey: PropertySaveKeys.state) as? String,
           let savedInitialTime = UserDefaults.standard.value(forKey: PropertySaveKeys.initialTime) as? TimeInterval,
           let savedAlarmSound = UserDefaults.standard.value(forKey: PropertySaveKeys.alarmSound) as? String {
            
            state = savedState == "running" ? .running : .default
            initialTime = savedInitialTime
            alarmSound = savedAlarmSound
        }
    }
    
    @objc private func save(){
        UserDefaults.standard.set(state == .running ? "running" : "stopped", forKey: PropertySaveKeys.state)
        UserDefaults.standard.set(initialTime, forKey: PropertySaveKeys.initialTime)
        UserDefaults.standard.set(alarmSound, forKey: PropertySaveKeys.alarmSound)
        
        backgroundTime = Date().timeIntervalSinceReferenceDate
    }
}
