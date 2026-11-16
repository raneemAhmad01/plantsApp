//
//  PlantReminder.swift
//  Plants App 🌱
//
//  MODEL — the data: what one plant reminder IS.
//  No SwiftUI here, only plain Swift.
//
 
import Foundation
 
struct PlantReminder: Identifiable {
    let id = UUID()
    var name: String
    var room: Room
    var light: Light
    var wateringDays: WateringDays
    var water: WaterAmount
    var isWatered = false
}
 
// MARK: - Choices for each picker
 
enum Room: String, CaseIterable, Identifiable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"
 
    var id: Self { self }
}
 
enum Light: String, CaseIterable, Identifiable {
    case fullSun = "Full sun"
    case partialSun = "Partial sun"
    case lowLight = "Low light"
 
    var id: Self { self }
 
    // Each light level gets its own SF Symbol
    var icon: String {
        switch self {
        case .fullSun:    "sun.max"
        case .partialSun: "cloud.sun"
        case .lowLight:   "moon"
        }
    }
}
 
enum WateringDays: String, CaseIterable, Identifiable {
    case everyDay = "Every day"
    case every2Days = "Every 2 days"
    case every3Days = "Every 3 days"
    case onceAWeek = "Once a week"
    case every10Days = "Every 10 days"
    case every2Weeks = "Every 2 weeks"

    var id: Self { self }

    // How many days between waterings — used to schedule the notification
    var days: Int {
        switch self {
        case .everyDay:    1
        case .every2Days:  2
        case .every3Days:  3
        case .onceAWeek:   7
        case .every10Days: 10
        case .every2Weeks: 14
        }
    }
}
 
enum WaterAmount: String, CaseIterable, Identifiable {
    case ml20to50 = "20-50 ml"
    case ml50to100 = "50-100 ml"
    case ml100to200 = "100-200 ml"
    case ml200to300 = "200-300 ml"
 
    var id: Self { self }
}
