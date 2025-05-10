//
//  DataModel.swift
//  PracticeAPI
//
//  Created by Engineer MacBook Air on 2025/05/10.
//

import Foundation

// 記事データを表す構造体
struct Article: Codable, Identifiable {
    let id: String
    let title: String // 記事のタイトル
    let url: String // 記事のURL
    let user: User // 投稿者の情報（ユーザーデータ）
    let createdAt: String // 記事が作成された日時　"2023-01-01T00:00:00+09:00" のような形式
    
    // JSONのキーとSwiftのプロパティ名をマッピング
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case user
        case createdAt = "created_at"
    }
}

// ユーザーデータを表す構造体
struct User: Codable, Identifiable {
    let id: String
    let name: String? // ユーザー名 (ない場合もある)
    let profileImageUrl: String? // プロフィール画像のURL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageUrl = "profile_image_url"
    }
}
