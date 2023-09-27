//
//  TimerModel.swift
//  Alarm
//
//  Created by 이재희 on 2023/09/27.
//

import UIKit
import AVFoundation

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
        static let endTime = "Timer_EndTime"
        static let pauseTime = "Timer_PauseTime"
        static let alarmSound = "Timer_AlarmSound"
    }
    
    //MARK: - Properties
    
    private(set) var state: State = .default
    private(set) var initialTime: TimeInterval = 0
    private(set) var endTime: TimeInterval = 0
    private(set) var pauseTime: TimeInterval = 0
    private(set) var alarmSound: String?
    private var timer: Timer?
    
    private var alarmPlayer: AVAudioPlayer?
    
    //MARK: - Life Cycle
    
    override init(){
        super.init()
        
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    //MARK: - Timer Control
    
    func start(withInitialTime initialTime: TimeInterval, endTime: TimeInterval, alarmSound: String?) {
        guard state != .running else {
            return
        }
        
        self.initialTime = initialTime
        self.endTime = endTime
        self.alarmSound = alarmSound
        
        if let soundName = alarmSound, let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                alarmPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                alarmPlayer = nil
            }
        }
        
        state = .running
        
        if pauseTime > 0 {
            let elapsedTimeSincePause = Date().timeIntervalSinceReferenceDate - pauseTime
            self.endTime -= elapsedTimeSincePause
            pauseTime = 0
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func pause() {
        guard state == .running else {
            return
        }
        
        timer?.invalidate()
        state = .paused
        
        pauseTime = Date().timeIntervalSinceReferenceDate
    }
    
    func resume() {
        guard state == .paused else {
            return
        }
        
        state = .running
        
        if pauseTime > 0 {
            let elapsedTimeSincePause = Date().timeIntervalSinceReferenceDate - pauseTime
            endTime -= elapsedTimeSincePause
            pauseTime = 0
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
        state = .default
        
        pauseTime = 0
    }
    
    @objc private func updateTimer() {
        if endTime <= 0 {
            stop()
            playAlarmSound()
        } else {
            endTime -= 1
        }
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
           let savedEndTime = UserDefaults.standard.value(forKey: PropertySaveKeys.endTime) as? TimeInterval,
           let savedPauseTime = UserDefaults.standard.value(forKey: PropertySaveKeys.pauseTime) as? TimeInterval,
           let savedAlarmSound = UserDefaults.standard.value(forKey: PropertySaveKeys.alarmSound) as? String {
            
            state = savedState == "running" ? .running : .default
            initialTime = savedInitialTime
            endTime = savedEndTime
            pauseTime = savedPauseTime
            alarmSound = savedAlarmSound
        }
    }
    
    @objc private func save(){
        UserDefaults.standard.set(state == .running ? "running" : "stopped", forKey: PropertySaveKeys.state)
        UserDefaults.standard.set(initialTime, forKey: PropertySaveKeys.initialTime)
        UserDefaults.standard.set(endTime, forKey: PropertySaveKeys.endTime)
        UserDefaults.standard.set(pauseTime, forKey: PropertySaveKeys.pauseTime)
        UserDefaults.standard.set(alarmSound, forKey: PropertySaveKeys.alarmSound)
    }
}
