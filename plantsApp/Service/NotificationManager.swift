//
//  NotificationManager.swift
//  Plants App 🌱
//
//  SERVICE — talks to iOS to schedule and cancel local notifications.
//  Not a ViewModel: it has no data for the screens, it just does one job
//  for the ViewModel ("remind the user about this plant").
//

import Foundation
import UserNotifications

final class NotificationManager {

    // Singleton: one shared instance for the whole app
    
    static let shared = NotificationManager()
    private init() {}

    private let center = UNUserNotificationCenter.current()

    // MARK: Permission
    // iOS shows the "Allow Notifications?" alert only the FIRST time.
    // After that, this just returns the user's answer.
    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    // MARK: Schedule
    // Repeats every N days (N comes from the plant's "Watering Days")
    func schedule(for reminder: PlantReminder) {
        let content = UNMutableNotificationContent()
        content.body = "Hey! let's water your \(reminder.name) 🪴"
        content.sound = .default

        let seconds = TimeInterval(reminder.wateringDays.days * 24 * 60 * 60)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: true)

        // Using the plant's id means: same plant → same notification.
        // Scheduling again (after an edit) replaces the old one instead of adding a second.
        let request = UNNotificationRequest(
            identifier: reminder.id.uuidString,
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    // MARK: Cancel
    func cancel(for reminder: PlantReminder) {
        center.removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
    }
}
