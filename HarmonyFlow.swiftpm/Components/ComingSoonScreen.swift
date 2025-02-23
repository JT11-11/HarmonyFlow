//
//  ComingSoon.swift
//  TCM
//
//  Created by Shadow33 on 21/2/25.
//

import SwiftUI

struct ComingSoonScreen: View {
    let tabName: String
    let icon: String
    let description: String
    
    private let theme = ThemeColors()
    @State private var isAnimating = false
    @State private var currentDate = Date()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }
    
    private var header: some View {
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "water.waves")
                        .font(.system(size: 30))
                        .foregroundColor(theme.primary)
                        .shadow(color: theme.primary.opacity(0.3), radius: 4, x: 0, y: 2)
                    
                    Text("Harmony Flow")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(theme.primary)
                        .shadow(color: theme.primary.opacity(0.3), radius: 4, x: 0, y: 2)
                }
            }
            
            // Date and Section Info
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(dateFormatter.string(from: currentDate))
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    Text(tabName)
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
    }
    
    private var iconSection: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 85, weight: .light))
                .foregroundColor(theme.primary)
                .padding()
                .background(
                    ZStack {
                        Circle()
                            .fill(theme.secondary.opacity(0.3))
                            .frame(width: 170, height: 170)
                        
                        Circle()
                            .stroke(theme.primary.opacity(0.2), lineWidth: 2)
                            .frame(width: 170, height: 170)
                    }
                )
        }
        .padding(.bottom, 25)
    }
    
    private var contentSection: some View {
        VStack(spacing: 18) {
            Text("Coming Soon")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(theme.primary)
                .shadow(color: theme.primary.opacity(0.1), radius: 2, x: 0, y: 1)
            
            Text(description)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 35)
                .lineSpacing(4)
        }
    }
    
    private var ctaSection: some View {
        VStack(spacing: 12) {
            Text("Stay Tuned!")
                .font(.system(size: 38, weight: .heavy, design: .rounded))
                .foregroundColor(.black)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .padding(.top, 25)
    }
    
    var body: some View {
        ZStack {
            theme.background
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                header
                ScrollView {
                    VStack(spacing: 35) {
                        Spacer()
                            .frame(height: 45)
                        
                        iconSection
                            .scaleEffect(isAnimating ? 1.0 : 0.8)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isAnimating)
                        
                        contentSection
                        ctaSection
                        
                        Spacer()
                            .frame(height: 70)
                    }
                }
                .onAppear {
                    isAnimating = true
                }
            }
        }
    }
}

private struct ThemeColors {
    let primary = Color(red: 0.1, green: 0.5, blue: 0.4)
    let secondary = Color(red: 0.8, green: 0.9, blue: 0.8)
    let background = Color(red: 0.96, green: 0.97, blue: 0.98)
}
