//
//  MainTabView.swift
//  PracticeProject
//
//  Created by Engineer MacBook Air on 2025/05/29.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("1", systemImage: "plus") {
                NextView(model: PracticeNavigationLinkModel())
            }
            Tab("2", systemImage: "plus") {
                PracticeNavigationLink()
            }
        }
    }
}

#Preview {
    MainTabView()
}
