//
//  SwiftUIView.swift
//  StudyDiary_SwiftUI
//
//  Created by 柳和花 on 2023/06/14.
//

import SwiftUI
import RealmSwift

class EventViewModel: ObservableObject {
    @Published var events = [Event]()
    
    init() {
        loadData()
    }
    func loadData() {
        let realm = try! Realm()
        let allEvents = realm.objects(Event.self)
        events = Array(allEvents)
    }
}
