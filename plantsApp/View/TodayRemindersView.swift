//
//  TodayRemindersView.swift
//  Plants App 🌱
//
//  VIEW — Screen 4 & 5: today's plants.
//  Draws the list; PlantsViewModel does the counting, sorting and changes.
//
 
import SwiftUI
 
struct TodayRemindersView: View {
 
    // @ObservedObject → this view RECEIVES the ViewModel (ContentView owns it)
    // and redraws whenever one of its @Published values changes
    @ObservedObject var viewModel: PlantsViewModel
 
    // What the "+" button does (opens the Set Reminder sheet)
    var onAdd: () -> Void = {}
 
    // What tapping a plant does (opens the sheet in edit mode)
    var onSelect: (PlantReminder) -> Void = { _ in }
 
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
 
            // MARK: Header
            Text("My Plants 🌱")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.primary)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 12)
 
            Divider()
 
            // MARK: Progress
            VStack(spacing: 16) {
                Text(viewModel.progressMessage)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())   // the number rolls when it changes
 
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.progressTrack)
 
                        Capsule()
                            .fill(Color.progressFill)
                            .frame(width: geo.size.width * viewModel.progress)
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal, 26)
            .padding(.top, 36)
            .padding(.bottom, 24)
 
            // MARK: List of plants
            List {
                ForEach(viewModel.sortedReminders) { reminder in
                    ReminderRow(reminder: reminder) {
                        viewModel.toggleWatered(reminder)
                    }
                    .contentShape(Rectangle())          // the whole row is tappable, not just the text
                    .onTapGesture {
                        onSelect(reminder)
                    }
                    .listRowBackground(Color(.systemBackground))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.delete(reminder)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .background(Color(.systemBackground))
        .overlay(alignment: .bottomTrailing) {
 
            // MARK: Floating "+" button
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.title2.weight(.medium))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.circle)
            .tint(Color.plantGreen)
            .accessibilityLabel("Add plant reminder")
            .padding(.trailing, 30)
            .padding(.bottom, 8)
        }
        .animation(.spring(duration: 0.4), value: viewModel.wateredCount)
    }
}
 
// MARK: - One row of the list
// Lives in this file because only this screen uses it
private struct ReminderRow: View {
    let reminder: PlantReminder
    var onToggle: () -> Void
 
    var body: some View {
        HStack(spacing: 16) {
 
            // Check circle
            Button(action: onToggle) {
                Image(systemName: reminder.isWatered ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(reminder.isWatered ? Color.checkGreen : Color.secondary)
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(reminder.isWatered ? "Mark as not watered" : "Mark as watered")
 
            // Plant info
            VStack(alignment: .leading, spacing: 6) {
                Label("in \(reminder.room.rawValue)", systemImage: "location")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
 
                Text(reminder.name)
                    .font(.title)
                    .foregroundStyle(.primary)
 
                HStack(spacing: 8) {
                    tag(reminder.light.rawValue,
                        icon: reminder.light.icon,
                        color: .lightTagText)
 
                    tag(reminder.water.rawValue,
                        icon: "drop",
                        color: .waterTagText)
                }
            }
            .opacity(reminder.isWatered ? 0.5 : 1)   // watered plants fade out
 
            Spacer()   // stretches the row to full width
        }
        .padding(.vertical, 8)
    }
 
    // A small helper that builds one rounded tag
    private func tag(_ text: String, icon: String, color: Color) -> some View {
        Label(text, systemImage: icon)
            .font(.caption)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.tagBackground, in: RoundedRectangle(cornerRadius: 8))
    }
}
 
// Colors come from Assets.xcassets (light + dark versions there)
 
// MARK: - Preview
#Preview {
    TodayRemindersView(viewModel: .preview)
}
