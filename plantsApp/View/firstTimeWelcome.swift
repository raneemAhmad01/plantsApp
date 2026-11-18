//
//  firstTimeWelcome.swift
//  plantsApp
//
//  Created by RaneemAhmad on 29/05/1448 AH.
//

import SwiftUI

struct firstTimeWelcome: View {
     
 
    // What happens when the button is tapped.
    // The screen doesn't decide this itself — whoever shows it passes the action in.
    var onSetReminder: () -> Void = {}
 
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
 
            // MARK: Content
            VStack(spacing: 0) {
                Spacer()
 
                Image(.GST_DACAR_121_02)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170, height: 200)
                    .accessibilityHidden(true) // decoration only
 
                Text("Start your plant journey!")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                    .padding(.top, 40)
 
                Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                    .font(.subheadline)
                    .foregroundStyle(Color.subtitleGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 16)
 
                Spacer()
 
                Button(action: onSetReminder) {
                    Text("Set Plant Reminder")
                        .font(.headline)
                        .frame(width: 250, height: 30)
                }
                .buttonStyle(.glassProminent)   // iOS 26 "Liquid Glass" button
                .tint(Color.plantGreen)
                .padding(.bottom, 120)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
    }
}
 
// Colors come from Assets.xcassets (light + dark versions there)
 
// MARK: - Preview
#Preview {
    firstTimeWelcome {
        print("Set Plant Reminder tapped")
    }
}
