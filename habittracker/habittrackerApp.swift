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
    var habitListController: HabitListController
    
    init() {
        habitListController = HabitListController(persistentContainer: persistenceController.container)
    }

    var body: some Scene {
        WindowGroup {
            HabitListView(controller: habitListController)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
        }
    }
}
