//
//  PracticeProjectApp.swift
//  PracticeProject
//
//  Created by Engineer MacBook Air on 2025/05/16.
//

import SwiftUI
import UserNotifications

@main
struct PracticeProjectApp: App {
    
    // 初期化時に表示
    init() {
        requestNotificationAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
    
    // 通知許可申請をユーザに表示
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Authorization error: \(error.localizedDescription)")
            } else {
                print("Permission granted: \(granted)")
            }
        }
    }
}
