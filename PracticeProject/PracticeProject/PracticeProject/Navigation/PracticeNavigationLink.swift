//
//  PracticeNavigationLink.swift
//  PracticeProject
//
//  Created by Engineer MacBook Air on 2025/05/29.
//

import SwiftUI
import RealmSwift

class PracticeNavigationLinkModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var fruitsName: String
}

struct PracticeNavigationLink: View {
    
    @ObservedResults(PracticeNavigationLinkModel.self) var fruits
    @State private var showAlert = false
    @State private var newTextField: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(fruits, id: \.id) { fruit in
                    NavigationLink(destination: NextView(model: fruit)) {
                        Text(fruit.fruitsName)
                    }
                }
            }
        }
    }
    

}

struct NextView: View {
    var model: PracticeNavigationLinkModel
    @State private var savedData: [PracticeNavigationLinkModel] = []
    @State private var newTextField: String = ""

    var body: some View {
        VStack {
            Button("保存") {
                saveModel()
            }
            TextField("", text: $newTextField)
        }
        .onAppear {
            newTextField = model.fruitsName
        }
    }
    
    private func saveModel() {
        let realm = try! Realm()
        try! realm.write {
            let model = PracticeNavigationLinkModel()
            model.fruitsName = newTextField
            realm.add(model)
        }
        newTextField = ""
    }
    
    private func loadSavedData() {
        let realm = try! Realm()
        let results = realm.objects(PracticeNavigationLinkModel.self)
        savedData = Array(results)
    }
}

#Preview {
    PracticeNavigationLink()
}
