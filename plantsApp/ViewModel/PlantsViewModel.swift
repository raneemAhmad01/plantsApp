//
//  PlantsViewModel.swift
//  Plants App 🌱
//
//  VIEWMODEL — the only one in the app.
//  Owns the list of plants and all the logic about it.
//  Views ask it questions ("how many are watered?") and tell it
//  what happened ("this plant was tapped"). It never draws anything.
//

import Foundation
import Combine   // ObservableObject and @Published come from Combine

final class PlantsViewModel: ObservableObject {

    // MARK: Data
    // @Published → every view watching this ViewModel redraws when it changes
    // private(set) → views can READ the list, but only this class can CHANGE it
    @Published private(set) var reminders: [PlantReminder]

    init(reminders: [PlantReminder] = []) {
        self.reminders = reminders
    }

    // MARK: Questions the views ask
    // Computed from `reminders`, so they don't need @Published —
    // when `reminders` changes, the view redraws and asks again

    var isEmpty: Bool {
        reminders.isEmpty
    }

    var allWatered: Bool {
        !reminders.isEmpty && reminders.allSatisfy { $0.isWatered }
    }

    var wateredCount: Int {
        reminders.filter { $0.isWatered }.count
    }

    var progress: Double {
        reminders.isEmpty ? 0 : Double(wateredCount) / Double(reminders.count)
    }

    var progressMessage: String {
        wateredCount == 0
            ? "Your plants are waiting for a sip 💦"
            : "\(wateredCount) of your plants feel loved today ✨"
    }

    // Plants that still need water stay on top, watered ones sink to the bottom
    var sortedReminders: [PlantReminder] {
        reminders.filter { !$0.isWatered } + reminders.filter { $0.isWatered }
    }

    // MARK: Actions the views trigger
    // The check circle
    func toggleWatered(_ reminder: PlantReminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isWatered.toggle()
        }
    }

    // MARK: Save — a brand-new plant (the + button)
    func save(name: String, room: Room, light: Light,
              wateringDays: WateringDays, water: WaterAmount) {
        let reminder = PlantReminder(
            name: cleaned(name),
            room: room,
            light: light,
            wateringDays: wateringDays,
            water: water
        )
        reminders.append(reminder)
    }

    // MARK: Update — an existing plant (tapping a row)
    // Changes only the fields, so the plant keeps its id and isWatered
    func update(_ reminder: PlantReminder, name: String, room: Room, light: Light,
                wateringDays: WateringDays, water: WaterAmount) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }

        reminders[index].name = cleaned(name)
        reminders[index].room = room
        reminders[index].light = light
        reminders[index].wateringDays = wateringDays
        reminders[index].water = water
    }

    // MARK: Delete
    func delete(_ reminder: PlantReminder) {
        reminders.removeAll { $0.id == reminder.id }
    }

    // MARK: Form rules
    // The ✓ button asks this before it can be tapped
    func canSave(name: String) -> Bool {
        !cleaned(name).isEmpty
    }

    // "  Pothos " → "Pothos"
    private func cleaned(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespaces)
    }
}
    


// MARK: - Sample data for previews
extension PlantsViewModel {
    static var preview: PlantsViewModel {
        PlantsViewModel(reminders: [
            PlantReminder(name: "Monstera", room: .kitchen,    light: .fullSun,    wateringDays: .everyDay,   water: .ml20to50),
            PlantReminder(name: "Pothos",   room: .bedroom,    light: .fullSun,    wateringDays: .everyDay,   water: .ml20to50),
            PlantReminder(name: "Orchid",   room: .livingRoom, light: .partialSun, wateringDays: .onceAWeek,  water: .ml20to50),
            PlantReminder(name: "Spider",   room: .kitchen,    light: .lowLight,   wateringDays: .every3Days, water: .ml50to100)
        ])
    }
}
