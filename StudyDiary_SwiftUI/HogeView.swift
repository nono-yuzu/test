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

struct ChartView: View {
    @State private var events = [Event]()
    @Binding var weekStudyMinutes: [Int]

    var body: some View {
        let data: [ChartEntry] = [
            
            
            .init(title: "月曜日", value: Double(weekStudyMinutes[6])),
            .init(title: "火曜日", value: Double(weekStudyMinutes[0])),
            .init(title: "水曜日", value: Double(weekStudyMinutes[1])),
            .init(title: "木曜日", value: Double(weekStudyMinutes[2])),
            .init(title: "金曜日", value: Double(weekStudyMinutes[3])),
            .init(title: "土曜日", value: Double(weekStudyMinutes[4])),
            .init(title: "日曜日", value: Double(weekStudyMinutes[5]))
            
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
        let pastSevenDaysEvents = allEvents.filter("date > %@", Calendar.current.date(byAdding: .day, value: -6, to: Date())!)
        events = Array(pastSevenDaysEvents)
    }

}

struct HogeView: View {
    @State private var back = false
    @State private var departureDate = Date()

    @State private var selectedhour = 0
    @State private var selectedmin = 0
    @State private var selectedall = 0
    @State private var events = [Event]()
    @State private var text = ""

    @State var weekStudyMinutes: [Int] = [5, 12, 7, 8, 8, 8, 10]

    var selectDate: Date?

    var body: some View {
        VStack {
            if let date = selectDate {
                Text("選択しています:\(getFormattedDate(date: date))")
            } else {
                Text("選択されていません")
            }

            Button(action: {
                back = true
            }) {
                Text("画面切り替え")
            }
            .fullScreenCover(isPresented: $back) {
                ContentView()
            }

            Button(action: {
                saveEvent()
                print(selectedhour)
                print(selectedmin)
            }) {
                Text("保存")
            }
            .onAppear() {
                print(loadData())
                //ここでチャートを過去七日間分だけ表示するために描画し直す初期化の処理とか必要そう
            }

            ChartView(weekStudyMinutes: $weekStudyMinutes)

            GeometryReader { geometry in
                HStack {
                    Text("勉強時間")
                    Picker(selection: $selectedhour, label: Text("language")) {
                        ForEach(0..<24) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .onReceive([self.selectedhour].publisher.first()) { hour in
                        print("hour: \(hour)")
                    }
                    .labelsHidden()
                    .frame(width: geometry.size.width / 3, height: geometry.size.height)
                    .clipped()

                    Picker(selection: $selectedmin, label: Text("language")) {
                        ForEach(0..<60) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .onReceive([self.selectedmin].publisher.first()) { min in
                        print("min: \(min)")
                    }
                    .labelsHidden()
                    .frame(width: geometry.size.width / 3, height: geometry.size.height)
                    .clipped()
                }
            }

            TextEditor(text: $text)
                .frame(width: 300, height: 200)
                .border(Color.gray, width: 1)
        }
    }

//    func saveEvent() {
//        selectedall = selectedhour * 60 + selectedmin
//        print(selectedall)
//        let realm = try! Realm()
//        try! realm.write {
//            let event = Event(value: ["date": selectDate ?? Date(), "hour": selectedhour, "min": selectedmin, "all": selectedall])
//            realm.add(event)
//            print(event)
//            print("保存しました")
//
//            // 入力した勉強時間をweekStudyMinutesに反映させる
//            weekStudyMinutes[getWeekdayIndex(date: event.date)] = event.all
//        }
//    }
    func saveEvent() {
        let jstTimeZone = TimeZone(identifier: "Asia/Tokyo")!
        let currentDate = Date()
        let jstDate = currentDate.addingTimeInterval(TimeInterval(jstTimeZone.secondsFromGMT(for: currentDate)))
        
        selectedall = selectedhour * 60 + selectedmin
        print(selectedall)
        let realm = try! Realm()
        try! realm.write {
            let event = Event(value: ["date": jstDate, "hour": selectedhour, "min": selectedmin, "all": selectedall])
            realm.add(event)
            print(event)
            print("保存しました")
            
            // 入力した勉強時間をweekStudyMinutesに反映させる
            weekStudyMinutes[getWeekdayIndex(date: event.date)] = event.all
        }
    }


    func loadData() {
        let realm = try! Realm()
        let allEvents = realm.objects(Event.self)
        let pastSevenDaysEvents = allEvents.filter("date > %@", Calendar.current.date(byAdding: .day, value: -6, to: Date())!)
        events = Array(pastSevenDaysEvents)
        
        // weekStudyMinutesを初期化
        weekStudyMinutes = [Int](repeating: 0, count: 7)
        
        // イベントの勉強時間をweekStudyMinutesに反映させる
        for event in events {
            weekStudyMinutes[getWeekdayIndex(date: event.date)] = event.all
        }
    }

    func getWeekdayIndex(date: Date) -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        // 曜日に応じたインデックスを返す（日曜日: 0, 月曜日: 1, ...）
        return weekday - 1
    }

}

private func getFormattedDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd"
    formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
    return formatter.string(from: date)
}

struct HogeView_Previews: PreviewProvider {
    static var previews: some View {
        HogeView()
    }
}

import Foundation

class Event: Object {
    @objc dynamic var hour = 0
    @objc dynamic var min = 0
    @objc dynamic var all = 0
    @objc dynamic var date = Date()
}
