//
//  HomeScreen.swift
//  TCM
//
//  Created by Shadow33 on 20/2/25.
//

import SwiftUI

struct HomeScreen: View {
    let primaryColor = Color(red: 0.2, green: 0.6, blue: 0.3)
    let secondaryColor = Color(red: 0.8, green: 0.9, blue: 0.8)
    var navigateToQiGong: () -> Void
    @State private var currentDate = Date()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        HStack(spacing: 12) {
                            Image(systemName: "water.waves")
                                .font(.system(size: 30))
                                .foregroundColor(primaryColor)
                                .shadow(color: primaryColor.opacity(0.3), radius: 4, x: 0, y: 2)
                            
                            Text("Harmony Flow")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(primaryColor)
                                .shadow(color: primaryColor.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(dateFormatter.string(from: currentDate))
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                            
                            Text("Ready for your practice?")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 20)
                .padding(.bottom, 15)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)

                ZStack(alignment: .bottomLeading) {
                    if let uiImage = UIImage(named: "mountain.jpg", in: Bundle.main, with: nil) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .clear,
                                        .black.opacity(0.3),
                                        .black.opacity(0.5)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(25)
                    }
                    
                    // Overlay text
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Daily Practice")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("Mindful Movement")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(25)
                }
                .padding(.horizontal, 25)
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Daily Qigong Practice")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("Restore balance and vitality through mindful movement")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        
                        // Practice Details
                        HStack(spacing: 30) {
                            PracticeDetailItem(
                                icon: "clock.fill",
                                title: "Duration",
                                detail: "3 mins"
                            )
                            
                            PracticeDetailItem(
                                icon: "flame.fill",
                                title: "Intensity",
                                detail: "Beginner"
                            )
                            
                            PracticeDetailItem(
                                icon: "figure.mind.and.body",
                                title: "Focus",
                                detail: "Energy"
                            )
                        }
                        .padding(.vertical, 10)
                        
                        Divider()
                            .padding(.vertical, 10)
                        
                        // Movement Preview
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Featured Movements")
                                .font(.system(size: 18, weight: .semibold))
                            
                            ForEach(["Standing Like a Tree", "Pushing the Mountain", "Gathering Qi", "Washing with Qi"], id: \.self) { movement in
                                MovementRow(
                                    movement: movement,
                                    color: primaryColor
                                )
                            }
                        }
                        .padding(.vertical, 10)
                        
                        Divider()
                            .padding(.vertical, 10)
                        
                        // Benefits Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Benefits")
                                .font(.system(size: 18, weight: .semibold))
                            
                            BenefitRow(icon: "heart.fill", text: "Improved circulation and energy flow")
                            BenefitRow(icon: "brain.head.profile", text: "Enhanced mental clarity and focus")
                            BenefitRow(icon: "lungs.fill", text: "Better breathing and stress relief")
                            BenefitRow(icon: "sparkles", text: "Increased flexibility and balance")
                        }
                        .padding(.vertical, 10)
                        
                        Button(action: navigateToQiGong) {
                            HStack {
                                Text("Begin Practice")
                                    .font(.system(size: 18, weight: .semibold))
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 20))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: primaryColor.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.top,20)
                        .padding(.bottom,40)
                    }
                    .padding(25)
                }
                .background(Color.white)
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.bottom, 30)
            }
            .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        }
    }


struct PracticeDetailItem: View {
    let icon: String
    let title: String
    let detail: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.primary)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Text(detail)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

struct MovementRow: View {
    let movement: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(color)
                .font(.system(size: 18))
            Text(movement)
                .font(.system(size: 16))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .font(.system(size: 16))
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}
