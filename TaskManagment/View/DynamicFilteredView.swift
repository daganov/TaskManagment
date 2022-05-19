//
//  DynamicFilteredView.swift
//  TaskManagment
//
//  Created by Denis Aganov on 18.05.2022.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    
    // MARK: - Core Data request
    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content
    
    // MARK: - Building custom ForEach which will give CoreData object to Build View
    init(dateToFilter: Date, @ViewBuilder content: @escaping (T) -> Content) {
        
        // MARK: Predicate to filter current date tasks
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: dateToFilter)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        // Filter Key
        let filterKey = "taskDate"
        
        // This will fetch tasks between today and tomorrow
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today, tomorrow])
        
        // Initializing Request with NSPredicate
        // Adding sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.taskDate, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("Список задач пуст")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
