//
//  Event.swift
//  StudyDiary_SwiftUI
//
//  Created by 柳和花 on 2023/04/21.
//

import Foundation
import RealmSwift

class Event: Object, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var hour = 0
    @objc dynamic var min = 0
    @objc dynamic var all = 0
    @objc dynamic var date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

