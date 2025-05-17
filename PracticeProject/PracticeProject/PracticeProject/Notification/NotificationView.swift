//
//  NotificationView.swift
//  PracticeProject
//
//  Created by Engineer MacBook Air on 2025/05/16.
//

import SwiftUI

struct NotificationView: View {
    @State private var selectedTime = Date()
    
    var body: some View {
        Button(action: {
            sendLocalPush()
        }) {
            Text("通知を出す")
        }
    }
    
    func sendLocalPush() {
        // 1. 通知の内容を作成
        let content = UNMutableNotificationContent()
        content.title = "ローカル通知です"
        content.subtitle = "こんにちは"
        content.sound = .default // 音を指定
        
        // 2. 通知のトリガーを指定
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // 5秒後に通知
        
        // 3. 中身とトリガーでリクエストを作成
        let request = UNNotificationRequest(identifier: "alerm_id", content: content, trigger: trigger)
        
        // 4. リクエストを追加
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NotificationView()
}
