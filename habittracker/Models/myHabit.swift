//
//  Habit.swift
//  habittracker
//
//  Created by Johan Karlsson on 2023-05-05.
//

import Foundation
import CoreData

class myHabit: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var createdAt: Date?
    @NSManaged var doneToday: Bool
    @NSManaged var completionDates: [Date]
    
    func calculateStreak(completionDates: [Date]) -> Int {
        let sortedDates = completionDates.sorted(by: >) // Sortera listan i fallande ordning
        var streak = 0
        var previousDate: Date?
        
        for date in sortedDates {
            if let previous = previousDate {
                let components = Calendar.current.dateComponents([.day], from: date, to: previous)
                if components.day == 1 { // Om datumet är dagen efter det föregående datumet, öka streak
                    streak += 1
                } else if components.day! > 1 { // Om det finns en daglängd mellan datum, bryt streak
                    break
                }
            }
            previousDate = date
            streak += 1 // Öka streak även för första datumet i listan
        }
        
        return streak
    }
}

