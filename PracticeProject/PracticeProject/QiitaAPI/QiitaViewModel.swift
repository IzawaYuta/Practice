//
//  QiitaViewModel.swift
//  PracticeAPI
//
//  Created by Engineer MacBook Air on 2025/05/10.
//

import SwiftUI

//@MainActor // UI更新をメインスレッドで行うことを保証
class QiitaViewModel: ObservableObject {
    @Published var articles: [Article] = [] // Qiita APIから取得した記事のリストを格納
    @Published var isLoading: Bool = false // APIからデータを取得中であるかどうか
    @Published var errorMessage: String? = nil // APIリクエスト中にエラーが発生した場合
    
    private let qiitaAPIURL = "https://qiita.com/api/v2/items"
    
    func fetchArticles(page: Int = 1, perPage: Int = 20) async {
        isLoading = true
        errorMessage = nil
        
        var urlComponents = URLComponents(string: qiitaAPIURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
            // 必要であれば "query" パラメータで検索も可能
            // URLQueryItem(name: "query", value: "SwiftUI")
        ]
        
        guard let url = urlComponents?.url else {
            errorMessage = "無効なURLです。"
            isLoading = false
            return
        }
        
        do {
            // URLSessionでデータを取得
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // HTTPステータスコードの確認
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                errorMessage = "サーバーエラー: ステータスコード \((response as? HTTPURLResponse)?.statusCode ?? 0)"
                isLoading = false
                return
            }
            
            // JSONデコード
            let decoder = JSONDecoder()
            // スネークケースからキャメルケースへの変換はデフォルトで対応していることが多いですが、
            // 明示的に設定する場合は以下のようにします。
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            // (今回のCodingKeys設定により、keyDecodingStrategyは不要)
            
            let fetchedArticles = try decoder.decode([Article].self, from: data)
            self.articles = fetchedArticles
            
        } catch let DecodingError.keyNotFound(key, context) {
            errorMessage = "デコードエラー: キーが見つかりません - \(key.stringValue), context: \(context.debugDescription)"
            print("codingPath: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context) {
            errorMessage = "デコードエラー: 型が一致しません - \(type), context: \(context.debugDescription)"
            print("codingPath: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            errorMessage = "デコードエラー: 値が見つかりません - \(value), context: \(context.debugDescription)"
            print("codingPath: \(context.codingPath)")
        } catch let DecodingError.dataCorrupted(context) {
            errorMessage = "デコードエラー: データが破損しています, context: \(context.debugDescription)"
            print("codingPath: \(context.codingPath)")
        }
        catch {
            errorMessage = "記事の取得に失敗しました: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
