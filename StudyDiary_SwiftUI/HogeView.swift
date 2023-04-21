//
//  HogeView.swift
//  StudyDiary_SwiftUI
//
//  Created by 柳和花 on 2023/04/21.
//

import SwiftUI
import RealmSwift
//２４時間のピッカー
struct HogeView: View {
    @State private var back = false
    @State private var departureDate = Date()
    @State private var selectedhour = 0
    @State private var selectedmin = 0
    @State private var selectedall = 0
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
                Text("test")
            }
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
        }
    }
    
    func saveEvent(){
//        selectedhour = selectedhour + 1
//        selectedmin = selectedmin + 1
//       全て分間算してrealmに保存
        selectedall = selectedhour * 60 + selectedmin
        print(selectedall)
        let realm = try! Realm()
        try! realm.write {
            let event = [Event(value: ["hour": selectedhour, "min": selectedmin, "all": selectedall])]
            realm.add(event)
            print(event)
//        selectedhour = selectedhour - 1
//        selectedmin = selectedmin - 1
        }
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

