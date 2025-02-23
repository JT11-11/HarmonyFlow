//
//  LandingScreen.swift
//  TCM
//
//  Created by Shadow33 on 20/2/25.
//
import SwiftUI

struct LandingScreen: View {
    @Binding var showPopup: Bool
    
    @State private var breathingCircleScale: CGFloat = 1.0
    @State private var titleOpacity: Double = 0
    
    let primaryColor = Color.green
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [primaryColor.opacity(0.3), .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            Circle()
                .fill(primaryColor.opacity(0.1))
                .scaleEffect(breathingCircleScale)
                .frame(width: 450, height: 450)
                .onAppear { startBreathingAnimation() }
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "water.waves")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(primaryColor)
                
                Text("Harmony Flow")
                    .font(.largeTitle.bold())
                    .opacity(titleOpacity)
                    .onAppear {
                        withAnimation(Animation.easeIn.delay(0.5)) {
                            titleOpacity = 1.0
                        }
                    }
                
                Text("Daily Qigong Practice")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .opacity(titleOpacity)
                
                Spacer()
            }
        }
    }
    
    private func startBreathingAnimation() {
        withAnimation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            breathingCircleScale = 1.3
        }
    }
}
