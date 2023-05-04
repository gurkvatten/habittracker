//
//  habittrackerApp.swift
//  habittracker
//
//  Created by Johan Karlsson on 2023-05-04.
//

import SwiftUI

@main
struct habittrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
