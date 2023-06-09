//
//  HogeView.swift
//  StudyDiary_SwiftUI
//
//  Created by 柳和花 on 2023/04/21.
//

import SwiftUI
import RealmSwift
import Charts
//２４時間のピッカー
struct HogeView: View {
    @State private var back = false
    @State private var departureDate = Date()
    @State private var selectedhour = 0
    @State private var selectedmin = 0
    @State private var selectedall = 0
    @State private var events = [Event]()
    @State private var text = ""
    
    @State var weekStudyMinutes: [Int] = [5, 12, 7, 8, 8, 8, 10]
    
    //    ContentView中のHogeView()の引数になってる
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
            .fullScreenCover(isPresented: $back){
                ContentView()
            }
            Button(action :{
                
                saveEvent()
                print(selectedhour)
                print(selectedmin)
            }) {
                Text("保存")
            }
            .onAppear() {
                print(loadData())
                // #TODO: 直近一週間のデータに絞る
                // #TODO: weekStudyMinutesの変数を更新
                // #TODO: weekStudyMinutesの変更をグラフに反映
            }
            
            ChartView(weekStudyMinutes: $weekStudyMinutes)
            GeometryReader { geometry in
                HStack{
                    Text("勉強時間")
                    Picker(selection: $selectedhour, label: Text("language")) {
                        
                        ForEach(0..<24) {
                            Text("\($0)")
                        }
                        
                    }
                    .pickerStyle(WheelPickerStyle())
                    .onReceive([self.selectedhour]
                        .publisher.first()) {
                            (hour) in
                            print("hour: \(hour)")
                        }.labelsHidden()
                        .frame(width: geometry.size.width / 3, height: geometry.size.height)
                        .clipped()
                    Picker(selection: $selectedmin, label: Text("language")) {
                        ForEach(0..<60) {
                            Text("\($0)")
                        }.pickerStyle(WheelPickerStyle())
                            .onReceive([self.selectedmin]
                                .publisher.first()) {
                                    (min) in
                                    print("min: \(min)")
                                }.labelsHidden()
                            .frame(width: geometry.size.width / 3, height: geometry.size.height)
                            .clipped()
                    }
                    .pickerStyle(.wheel)
                    .padding()
                }
            }
            TextEditor(text: $text)
                .frame(width: 300, height: 200)
                .border(Color.gray, width: 1)
        }
        
    }
    
    func saveEvent(){
        //       全て分間算してrealmに保存
        selectedall = selectedhour * 60 + selectedmin
        print(selectedall)
        let realm = try! Realm()
        try! realm.write {
            let event = [Event(value: ["date": selectDate ?? Date(), "hour": selectedhour, "min": selectedmin, "all": selectedall])]
            realm.add(event)
            print(event)
            print("保存しました")
            
        }
    }
    
    func loadData() -> Array<Any> {
        let realm = try! Realm()
        let allEvents = realm.objects(Event.self)
        events = Array(allEvents)
        return events
    }
}



private func getFormattedDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd"
    return formatter.string(from: date)
}



struct HogeView_Previews: PreviewProvider {
    static var previews: some View {
        HogeView()
    }
}

