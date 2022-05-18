import SwiftUI

class TaskViewModel: ObservableObject {
    
    // MARK: Current Week Days
    @Published var currentWeek = [Date]()
    
    // MARK: Current Day
    @Published var currentDay = Date()
    
    // MARK: Filtering Today Tasks
    @Published var filteredTasks: [Task]?
    
    // MARK: New Task
    @Published var addNewTask = false
    
    init() {
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru")
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    // MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // MARK: Checking if current date is today
    func isToday(date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: currentDay)
    }
    
    // MARK: Checking if currentHour is task Hour
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
