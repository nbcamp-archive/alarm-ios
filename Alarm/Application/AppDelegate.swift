//
//  AppDelegate.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-25.
//

import AlarmNotification
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 애플리케이션 실행 시 알림 사용권한을 먼저 확인
        ANAuthenticator.checkPermission { status in
            switch status {
            case .authorized:
                print("사용자가 사용권한을 허용한 상태입니다.")
            case .denied:
                print("사용자가 사용권한을 거부한 상태입니다.")
                ANAuthenticator.redirectSettings()
            case .notDetermined:
                print("사용자가 사용권한을 결정하지 않은 상태입니다.")
                ANAuthenticator.requestPermission { granted in
                    if granted {
                        print("사용자가 알림 사용권한을 허용했습니다.")
                    } else {
                        print("사용자가 알림 사용권한을 거부했습니다.")
                    }
                }
            case .provisional:
                print("사용권한이 활성화 되어있지만 조용한 알림도 허용한 상태입니다.")
            case .ephemeral:
                print("사용권한을 허용하지만 단 한번만 허용한 상태입니다.")
            @unknown default:
                break
            }
        }
        
        UNUserNotificationCenter.current().requestAuthorization (options: [UNAuthorizationOptions.sound, .alert])
        { (granted, error) in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
            print("granted \(granted)")
        }

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        let trigger = notification.request.trigger
        
        completionHandler([UNNotificationPresentationOptions.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content = response.notification.request.content
        let trigger = response.notification.request.trigger
        
        completionHandler()
    }
}
