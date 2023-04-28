//
//  ChartView.swift
//  StudyDiary_SwiftUI
//
//  Created by 柳和花 on 2023/04/28.
//

import SwiftUI
import Charts
import RealmSwift

struct ChartEntry: Identifiable {
    var all = 0
    var date = Date()
    var color: Color = .green
    var id: String {
        return title + String(value)
    }
    
//    @objc dynamic var hour = 0
//    @objc dynamic var min = 0
//    @objc dynamic var all = 0
//    @objc dynamic var date = Date()
}
struct ChartView: View {
    @State private var events = [Event]()
   
    var body: some View {
        let data: [ChartEntry] = [
            .init(date: "n日", value: 24),
            .init(date: "n+1日", value: 12),
            .init(date: "n+2日", value: 8)
        ]

        Chart {
            ForEach(data) { dataPoint in
                LineMark(
                    x: .value("Category", dataPoint.title),
                    y: .value("Value", dataPoint.value)
                )
                .foregroundStyle(dataPoint.color)
                PointMark(
                    x: .value("Category", dataPoint.title),
                    y: .value("Value", dataPoint.value)
                )
            }
        }
        .frame(height: 200)
        .onAppear {
              loadData()
          }
    }
    func loadData() {
        let realm = try! Realm()
        let allEvents = realm.objects(Event.self)
        events = Array(allEvents)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
