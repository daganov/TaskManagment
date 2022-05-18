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
        
        // Initializing Request with NSPredicate
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [])
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
