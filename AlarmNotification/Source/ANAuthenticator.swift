//
//  ANAuthenticator.swift
//  AlarmNotification
//
//  Created by Yujin Kim on 2023-10-02.
//

import UIKit
import UserNotifications

@available(iOS 14.0, *)
public class ANAuthenticator {
    
    /// 알림 사용권한을 허용했는지 확인하는 메서드입니다.
    public static func checkPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    /// 알림 사용권한을 사용자에게 요청하는 메서드입니다.
    /// - `UNUserAuthorizationOptions.badge` 설정은 사용하지 않습니다.
    public static func requestPermission(completion: @escaping (Bool) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            completion(granted)
        }
    }
    /// 사용자가 임의로 설정에서 알림 사용권한을 해제한 경우 실행되는 메서드입니다.
    /// 앱이 다시 실행될 때마다 강제로 설정 화면으로 이동하게 됩니다.
    public static func redirectSettings() {
        if let settingURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
        }
    }
    
}
