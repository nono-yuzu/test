//
//  ContentView.swift
//  StudyDiary_SwiftUI
//
//  Created by 柳和花 on 2023/04/21.
//

import SwiftUI
import FSCalendar
import RealmSwift


struct ContentView: View {
    @State private var selectedDate: Date?
    @State  var selectedDate_2: Date = Date()
    @State private var path = [String]()
    @State private var show = false
    @State private var events = [Event]()
    
    var body: some View {
        VStack {
            
            CalendarTestView(selectedDate: $selectedDate)
                .frame(width: 400, height: 500)
            Spacer()
            
            if let date = selectedDate {
                Label(getFormattedDate(date: date), systemImage: "calendar")
                if let event = events.filter({getFormattedDate(date: $0.date) == getFormattedDate(date: date)}).first {
                    Text("勉強時間: \(event.hour)時間\(event.min)分")
                }
            }

            else {
                Text("選択されていません")
            }
                        
            
            Button(action: {
                show = true
                
            }) {
                Text("画面の切り替え")
            }
            .fullScreenCover(isPresented: $show){
                HogeView(selectDate: selectedDate)
            }
            
            
        }
        .padding()

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

private func getFormattedDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ja_JP")
    formatter.dateFormat = "MM/dd"
    return formatter.string(from: date)
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

