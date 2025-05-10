//
//  QiitaView.swift
//  PracticeAPI
//
//  Created by Engineer MacBook Air on 2025/05/10.
//

import SwiftUI

struct QiitaView: View {
    @StateObject private var viewModel = QiitaViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("記事を読み込み中...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("エラー: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                    Button("再試行") {
                        Task {
                            await viewModel.fetchArticles()
                        }
                    }
                } else {
                    List(viewModel.articles) { article in
                        ArticleRow(article: article)
                    }
                }
            }
            .navigationTitle("Qiita 記事")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await viewModel.fetchArticles()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .onAppear {
                // Viewが表示された時に記事を取得
                if viewModel.articles.isEmpty { // 初回のみ自動読み込み
                    Task {
                        await viewModel.fetchArticles()
                    }
                }
            }
        }
    }
}

//記事一行分のView
struct ArticleRow: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let imageUrlString = article.user.profileImageUrl, let imageUrl = URL(string: imageUrlString) {
                    AsyncImage(url: imageUrl) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                }
                Text(article.user.name ?? article.user.id) // ユーザー名がなければIDを表示
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(article.title)
                .font(.headline)
                .lineLimit(2) // タイトルを2行までに制限
            
            Text("作成日: \(formattedDate(from: article.createdAt))")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            // 記事URLへのリンク (タップでSafariで開く)
            if let url = URL(string: article.url) {
                Link("続きを読む...", destination: url)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
    
    // 日付文字列をフォーマットするヘルパー関数
    private func formattedDate(from dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Qiitaの形式に合わせる
        
        if let date = isoFormatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            displayFormatter.locale = Locale(identifier: "ja_JP")
            return displayFormatter.string(from: date)
        }
        return dateString // パース失敗時は元の文字列を返す
    }
}

#Preview {
    QiitaView()
}
