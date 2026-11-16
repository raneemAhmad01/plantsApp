//  ContentView.swift
//  Plants App 🌱
//
//  VIEW — the "traffic controller": decides which screen to show.
//  It creates the ViewModel and asks it what state the app is in.
//

import SwiftUI

struct ContentView: View {

    // @StateObject → this view CREATES and OWNS the ViewModel,
    // and keeps it alive as long as the view exists
    @StateObject private var viewModel = PlantsViewModel()

    // Screen-only state stays in the View (it's about navigation, not data)
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showSetReminder = false
    @State private var editingReminder: PlantReminder?

    var body: some View {
        Group {
            if !hasSeenOnboarding {
                firstTimeWelcome {
                    hasSeenOnboarding = true
                    showSetReminder = true
                }
            } else if viewModel.isEmpty {
                NoRemindersView {
                    showSetReminder = true
                }
            } else if viewModel.allWatered {
                AllDoneView {
                    showSetReminder = true
                }
            } else {
                TodayRemindersView(
                    viewModel: viewModel,
                    onAdd: { showSetReminder = true },
                    onSelect: { reminder in editingReminder = reminder }
                )
            }
        }
        // Add mode
        .sheet(isPresented: $showSetReminder) {
            SetReminderView(viewModel: viewModel)
        }
        // Edit mode — opens whenever editingReminder is not nil
        .sheet(item: $editingReminder) { reminder in
            SetReminderView(viewModel: viewModel, reminder: reminder)
        }
    }
}

#Preview {
    ContentView()
}
