//
//  NotificationView.swift
//  PracticeProject
//
//  Created by Engineer MacBook Air on 2025/05/16.
//

import SwiftUI

struct NotificationView: View {
    
    @State private var selectedDate = Date() // 通知を設定する日時を保持
    
    var body: some View {
        VStack(spacing: 20) {
            // DatePickerで日時を選択
            DatePicker("通知日時", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .padding()
                .datePickerStyle(.graphical) // スタイルはお好みで
            
            Button("日付を決めて通知を設定") {
                scheduleNotification()
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button(action: {
                sendLocalPush()
            }) {
                Text("通知を出す")
            }
        }
    }
    
    // ボタンタップで通知
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
    
    func scheduleNotification() {
        // 3. 通知内容の作成
        let content = UNMutableNotificationContent()
        content.title = "時間です！"
        content.body = "設定された時間になりました。\nこれはローカル通知です。"
        content.sound = UNNotificationSound.default
        // content.badge = 1 // アプリアイコンにバッジを表示する場合 (数値は任意)
        // content.userInfo = ["customDataKey": "重要な情報"] // 通知にカスタムデータを付加する場合
        
        // 4. 通知トリガーの作成 (カレンダーベース)
        // DatePickerで選択された日時からDateComponentsを生成
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        
        // 過去の日時が指定された場合は警告し、処理を中断
        if selectedDate <= Date() {
            print("エラー: 過去の日時が指定されました。通知は設定されません。")
            return
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // 5. 通知リクエストの作成と登録
        let requestIdentifier = "myLocalNotification_\(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知のスケジュールに失敗しました: \(error.localizedDescription)")
            } else {
                print("通知が正常にスケジュールされました: \(selectedDate) に発火します。")
            }
        }
    }
}

#Preview {
    NotificationView()
}
