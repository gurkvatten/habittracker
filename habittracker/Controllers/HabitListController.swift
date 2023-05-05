//
//  HabitListController.swift
//  habittracker
//
//  Created by Johan Karlsson on 2023-05-05.
//

import Foundation
import CoreData

class HabitListController: ObservableObject {
    @Published var habits: [myHabit] = []
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        //fetchHabits()
    }
    
    func addHabit(name: String) {
        let habit = Habit(context: persistentContainer.viewContext)
        habit.name = name
        habit.createdAt = Date()
        habit.doneToday = false
        saveContext()
       // fetchHabits()
    }
    
    func deleteHabit(at indexSet: IndexSet) {
        indexSet.forEach { index in
            persistentContainer.viewContext.delete(habits[index])
        }
        saveContext()
       // fetchHabits()
    }
    
    func toggleDone(for habit: Habit) {
        habit.doneToday = !habit.doneToday
        saveContext()
       // fetchHabits()
    }
    
    /*private func fetchHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.name, ascending: true)]
        do {
            habits = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetching habits: \(error)")
        }
    }
    */
    
    
    private func saveContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
