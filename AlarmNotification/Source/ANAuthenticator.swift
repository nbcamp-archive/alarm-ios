//
//  ANAuthenticator.swift
//  AlarmNotification
//
//  Created by Yujin Kim on 2023-10-02.
//

import Foundation
import UserNotifications

@available(iOS 14.0, *)
public class ANAuthenticator {
    
    /// 알람 사용권한을 허용했는지 확인하는 메서드입니다.
    public static func checkPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    /// 알람 사용권한을 사용자에게 요청하는 메서드입니다.
    /// - `UNUserAuthorizationOptions.badge` 설정은 사용하지 않습니다.
    public static func requestPermission(completion: @escaping (Bool) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            completion(granted)
        }
    }
    
}
