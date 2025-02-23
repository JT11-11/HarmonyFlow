//
//  BottomPopup.swift
//  TCM
//
//  Created by Shadow33 on 20/2/25.
//
import SwiftUI

struct BottomPopup: View {
    @Binding var showPopup: Bool
    @Binding var navigateToHome: Bool
    
    @State private var buttonScale: CGFloat = 0.95
    
    // Colors
    let primaryColor = Color(red: 0.1, green: 0.5, blue: 0.4)
    let backgroundColor = Color.white
    
    var body: some View {
        VStack(spacing: 30) {
            // Handle indicator
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 5)
                .cornerRadius(2.5)
                .padding(.top, 10)
            
            Text("Begin Your Journey")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(primaryColor)
            
            Text("Discover the ancient art of Qigong and improve your physical and mental wellbeing with guided practices.")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
                        
            // Begin button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    buttonScale = 1.05
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring()) {
                            buttonScale = 1.0
                            showPopup = false
                            
                            // Navigate to home screen after popup closes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    navigateToHome = true
                                }
                            }
                        }
                    }
                }
            }) {
                Text("Begin Your Journey")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 320, height: 70)
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(primaryColor)
                            .shadow(color: primaryColor.opacity(0.5), radius: 10, x: 0, y: 5)
                    )
            }
            .scaleEffect(buttonScale)
            .padding(.vertical, 20)
        }
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity)
        .background(
            backgroundColor
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
    }
}

