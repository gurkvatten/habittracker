//
//  habittrackerApp.swift
//  habittracker
//
//  Created by Johan Karlsson on 2023-05-04.
//

import SwiftUI
import CoreData

@main
struct habittrackerApp: App {
    let persistenceController = PersistenceController.shared
    let habit = Habit() // create a new instance of Habit

    var body: some Scene {
        WindowGroup {
            HabitListView(habit: habit) // pass the habit instance to HabitListView
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
