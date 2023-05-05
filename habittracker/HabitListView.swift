//
//  HabitListView.swift
//  habittracker
//
//  Created by Johan Karlsson on 2023-05-04.
//
// did everything in the view this time all my code dissapeared when i branched off so this time its not mvc
import SwiftUI
import CoreData

struct HabitListView_Previews: PreviewProvider {
    @State static var habit = Habit(context: PersistenceController.preview.container.viewContext)
    static var previews: some View {
        HabitListView(habit: habit)
        
    }
}

struct HabitListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Habit.name, ascending: true)], animation: .default)
        private var habits: FetchedResults<Habit>
    @ObservedObject var habit: Habit
    
    @State private var showingAddHabitView = false
    @State private var newHabitName = ""
       
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits, id: \.self) { habit in
                    HStack {
                        Text(habit.name ?? "")
                        Spacer()
                        
                        Text("Streak: \(habit.streak)")
                                    .font(.caption)
                        
                        if habit.doneToday == false {
                            Button(action: {
                                habit.streak = +1
                            }) {
                                Text("Done Today")
                            }
                        }
                    }
                
                }
                .onDelete(perform: deleteHabit)
            }
            .navigationBarTitle("Habits")
            .navigationBarItems(trailing:
                                    Button(action: {
                showingAddHabitView = true
            }) {
                Image(systemName: "plus")
            }
            )
            .sheet(isPresented: $showingAddHabitView) {
                AddHabitView(habitName: $newHabitName, isPresented: $showingAddHabitView)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    private func addHabit() {
            withAnimation {
                let newHabit = Habit(context: viewContext)
                newHabit.name = newHabitName
                newHabit.createdAt = Date()
                newHabit.doneToday = false

                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }

                newHabitName = ""
            }
        }
    private func updateHabit(_ habit: Habit) {
        habit.doneToday = !habit.doneToday // Updates done today
        saveContext() // saves to Core Data
    }
    
    func calculateStreak(completionDates: [Date]) -> Int {
        let sortedDates = completionDates.sorted(by: >) //sorts list
        var streak = 0
        var previousDate: Date?
        
        for date in sortedDates {
            if let previous = previousDate {
                let components = Calendar.current.dateComponents([.day], from: date, to: previous)
                if components.day == 1 { //increases streak
                    streak += 1
                } else if components.day! > 1 { // deletes streak
                    break
                }
            }
            previousDate = date
            streak += 1 // increases streak first day
        }
        
        return streak
    }
    

    


    
    private func deleteHabit(at offsets: IndexSet) {
        for index in offsets {
            let habit = habits[index]
            viewContext.delete(habit)
        }
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    struct AddHabitView: View {
        @Environment(\.managedObjectContext) private var viewContext
        
        @Binding var habitName: String
        @Binding var isPresented: Bool
        
        var body: some View {
            VStack {
                TextField("Enter habit name", text: $habitName)
                    .padding()
                
                Button("Add Habit") {
                    let newHabit = Habit(context: viewContext)
                    newHabit.name = habitName
                    
                    do {
                        try viewContext.save()
                    } catch {
                        print("Error saving habit: \(error)")
                    }
                    
                    habitName = ""
                    isPresented = false // closes view
                }
            }
        }
    }
}
