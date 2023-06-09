//
//  ChartView.swift
//  StudyDiary_SwiftUI
//
//  Created by 柳和花 on 2023/04/28.
//

//gitはtestに保存してある
import SwiftUI
import Charts
import RealmSwift

struct ChartEntry: Identifiable {
    var title: String
    var value: Double
    var color: Color = .green
    var id: String {
        return title + String(value)
    }
}
    
//    @objc dynamic var hour = 0
//    @objc dynamic var min = 0
//    @objc dynamic var all = 0
//    @objc dynamic var date = Date()

struct ChartView: View {
    @State private var events = [Event]()
//    let weekStudyMinutes: [Int] = [5, 12, 7, 8, 8, 8, 10]
    @Binding var weekStudyMinutes: [Int]
    
    var body: some View {
        let data: [ChartEntry] = [
            .init(title: "月曜日", value: Double(weekStudyMinutes[0])),
            .init(title: "火曜日", value: Double(weekStudyMinutes[1])),
            .init(title: "水曜日", value: Double(weekStudyMinutes[2])),
            .init(title: "木曜日", value: Double(weekStudyMinutes[3])),
            .init(title: "金曜日", value: Double(weekStudyMinutes[4])),
            .init(title: "土曜日", value: Double(weekStudyMinutes[5])),
            .init(title: "日曜日", value: Double(weekStudyMinutes[6]))
        ]

        Chart {
            ForEach(data) { dataPoint in
                LineMark(
                    x: .value("Category", dataPoint.title),
                    y: .value("Value", dataPoint.value)
                )
                .foregroundStyle(dataPoint.color)
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
//
//struct ChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChartView(weekStudyMinutes: [5, 12, 7, 8, 8, 8, 10])
//    }
//}
