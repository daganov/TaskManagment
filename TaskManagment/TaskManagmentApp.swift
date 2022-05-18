//
//  TaskManagmentApp.swift
//  TaskManagment
//
//  Created by Denis Aganov on 18.05.2022.
//

import SwiftUI

@main
struct TaskManagmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
