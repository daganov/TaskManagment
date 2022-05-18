//
//  NewTask.swift
//  TaskManagment
//
//  Created by Denis Aganov on 18.05.2022.
//

import SwiftUI

struct NewTask: View {
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Task Values
    @State var taskTitle = ""
    @State var taskDescription = ""
    @State var taskDate = Date()
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    TextField("Go to work", text: $taskTitle)
                } header: {
                    Text("Заголовок")
                }

                Section {
                    TextField("Nothing", text: $taskDescription)
                } header: {
                    Text("Описание")
                }

                Section {
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                } header: {
                    Text("Дата")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Новая задача")
            .navigationBarTitleDisplayMode(.inline)
            // MARK: Disabling dismiss on Swipe
            .interactiveDismissDisabled()
            // MARK: Action Buttons
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        let task = Task(context: context)
                        task.taskTitle = taskTitle
                        task.taskDescription = taskDescription
                        task.taskDate = taskDate
                        
                        // Saving
                        try? context.save()
                        // Dismissing View
                        dismiss()
                    }
                    .disabled(taskTitle == "" || taskDescription == "")
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
        }
    }
}
