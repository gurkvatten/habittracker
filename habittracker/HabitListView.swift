//
//  HabitListView.swift
//  habittracker
//
//  Created by Johan Karlsson on 2023-05-04.
//

import SwiftUI
import CoreData

import SwiftUI



struct HabitListView: View {
    @ObservedObject var controller: HabitListController
    
    @State private var showingAddHabitView = false
    @State private var newHabitName = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach($controller.habits) { habit in
                    HStack {
                        Text(habit.name)
                        Spacer()
                        Text("Streak: \(habit.streak)")
                            .font(.caption)
                        Button(action: {
                            controller.updateHabit(habit)
                        }) {
                            Text(habit.doneToday ? "Done Today" : "Not Done")
                        }
                    }
                }
                .onDelete(perform: controller.deleteHabit)
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
                AddHabitView(newHabitName: $newHabitName, isPresented: $showingAddHabitView, controller: controller)
            }
        }
    }
}

struct AddHabitView: View {
    @Binding var newHabitName: String
    @Binding var isPresented: Bool
    var controller: HabitListController
    
    var body: some View {
        VStack {
            TextField("Enter habit name", text: $newHabitName)
                .padding()
            
            Button("Add Habit") {
                controller.addHabit(name: newHabitName)
                newHabitName = ""
                isPresented = false // stänger AddHabitView
            }
        }
    }
}
