//
//  NoRemindersView.swift
//  plantsApp
//
//  Created by RaneemAhmad on 30/05/1448 AH.
//

import SwiftUI
 
struct NoRemindersView: View {
 
    // What the "+" button does (opens the Set Reminder sheet)
    var onAdd: () -> Void = {}
 
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
 
            // MARK: Empty message
            Text("No reminders set yet..")
                .font(.title3)
                .foregroundStyle(Color.emptyGray)
                .frame(maxWidth: .infinity, maxHeight: .infinity) // fill the space → text lands in the center
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
    }
}
 
// Colors come from Assets.xcassets (light + dark versions there)
 
// MARK: - Preview
#Preview {
    NoRemindersView {
        print("+ tapped")
    }
}
