//
//  CalendarTest.swift
//  StudyDiary_SwiftUI
//
//  Created by 柳和花 on 2023/04/21.
//

import SwiftUI
import FSCalendar
import RealmSwift


struct CalendarTestView: UIViewRepresentable {
    @Binding var selectedDate: Date?
    
    func makeUIView(context: Context) -> UIView {
        let fscalendar = FSCalendar()
        fscalendar.delegate = context.coordinator
        return fscalendar
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No update needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedDate: $selectedDate)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate {
        @Binding var selectedDate: Date?
        
        init(selectedDate: Binding<Date?>) {
            self._selectedDate = selectedDate
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            selectedDate = date
        }
        
        func getTime(hour: String) {
            let realm = try! Realm()
            var result = realm.objects(Event.self)
            result = result.filter("hour = '\(hour)'")
            let event = result.last!
            print(event.all)
            
        }
    }
    
    
    
}
