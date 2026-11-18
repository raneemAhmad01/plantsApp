//
//  AllDoneView.swift
//  plantsApp
//
//  Created by RaneemAhmad on 01/06/1448 AH.
//

import SwiftUI

struct AllDoneView: View {
    // What the "+" button does (opens the Set Reminder sheet)
    var onAdd: () -> Void = {}
    
    // Drives the little "pop" when the screen appears
    @State private var appeared = false
    
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
                
                Image(.allDone)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 164, height: 200)
                
                Text("All Done! 🎉")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                    .padding(.top, 33)
                
                Text("All Reminders Completed")
                    .font(.subheadline)
                    .foregroundStyle(Color.subtitleGray)
                    .padding(.top, 12)
                
                Spacer()
                Spacer()   // two spacers below → content sits a bit above center
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
        .onAppear {
            withAnimation(.spring(duration: 0.6, bounce: 0.4)) {
                appeared = true
            }
        }
    }
}
     
    // MARK: - Preview
#Preview {
        AllDoneView {
            print("+ tapped")
        }
}
