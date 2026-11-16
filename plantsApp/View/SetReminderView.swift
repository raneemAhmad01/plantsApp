//
//  SetReminderView.swift
//  Plants App 🌱
//
//  VIEW — Screen 3 & 6: one sheet, two modes.
//  • Add  → SetReminderView(viewModel: vm)                   empty fields
//  • Edit → SetReminderView(viewModel: vm, reminder: plant)  filled in + Delete button
//
//  The sheet only holds what the user is typing (@State draft).
//  Saving, updating and deleting are done by PlantsViewModel.
//

import SwiftUI

struct SetReminderView: View {

    // Lets the sheet close itself
    @Environment(\.dismiss) private var dismiss

    // The app's ViewModel — ContentView owns it, the sheet calls its functions
    @ObservedObject var viewModel: PlantsViewModel

    // The plant being edited — nil means "adding a new one"
    private let reminder: PlantReminder?

    // MARK: Form draft
    @State private var name: String
    @State private var room: Room
    @State private var light: Light
    @State private var wateringDays: WateringDays
    @State private var water: WaterAmount

    // MARK: Init — the plant's values in edit mode, the design's defaults in add mode
    init(viewModel: PlantsViewModel, reminder: PlantReminder? = nil) {
        self.viewModel = viewModel
        self.reminder = reminder

        _name         = State(initialValue: reminder?.name ?? "")
        _room         = State(initialValue: reminder?.room ?? .bedroom)
        _light        = State(initialValue: reminder?.light ?? .fullSun)
        _wateringDays = State(initialValue: reminder?.wateringDays ?? .everyDay)
        _water        = State(initialValue: reminder?.water ?? .ml20to50)
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Plant name
                Section {
                    HStack {
                        Text("Plant Name")
                        TextField("Pothos", text: $name)
                    }
                }

                // MARK: Where it lives
                Section {
                    Picker(selection: $room) {
                        ForEach(Room.allCases) { room in
                            Text(room.rawValue)
                        }
                    } label: {
                        Label("Room", systemImage: "location")
                    }

                    Picker(selection: $light) {
                        ForEach(Light.allCases) { light in
                            Label(light.rawValue, systemImage: light.icon)
                        }
                    } label: {
                        Label("Light", systemImage: "sun.max")
                    }
                }

                // MARK: Watering
                Section {
                    Picker(selection: $wateringDays) {
                        ForEach(WateringDays.allCases) { days in
                            Text(days.rawValue)
                        }
                    } label: {
                        Label("Watering Days", systemImage: "drop")
                    }

                    Picker(selection: $water) {
                        ForEach(WaterAmount.allCases) { amount in
                            Text(amount.rawValue)
                        }
                    } label: {
                        Label("Water", systemImage: "drop")
                    }
                }

                // MARK: Delete — only in edit mode
                if let reminder {
                    Section {
                        Button(role: .destructive) {
                            viewModel.delete(reminder)
                            dismiss()
                        } label: {
                            Text("Delete Reminder")
                                .frame(maxWidth: .infinity)   // centered, like the design
                        }
                    }
                }
            }
            .pickerStyle(.menu)      // the "Bedroom ⌃⌄" style from the design
            .tint(Color.plantGreen)  // green text cursor
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        checkmarkTapped()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color.plantGreen)
                    .disabled(!viewModel.canSave(name: name))
                }
            }
        }
    }

    // MARK: ✓ — the sheet only decides WHICH ViewModel function to call
    private func checkmarkTapped() {
        if let reminder {
            viewModel.update(reminder, name: name, room: room, light: light,
                             wateringDays: wateringDays, water: water)
        } else {
            viewModel.save(name: name, room: room, light: light,
                           wateringDays: wateringDays, water: water)
        }
        dismiss()
    }
}

// MARK: - Previews
#Preview("Add") {
    Color(.systemBackground)
        .sheet(isPresented: .constant(true)) {
            SetReminderView(viewModel: .preview)
        }
}

#Preview("Edit") {
    let viewModel = PlantsViewModel.preview

    Color(.systemBackground)
        .sheet(isPresented: .constant(true)) {
            SetReminderView(viewModel: viewModel, reminder: viewModel.reminders[1])
        }
}
