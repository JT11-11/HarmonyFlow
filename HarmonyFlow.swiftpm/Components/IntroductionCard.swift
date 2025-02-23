//
//  IntroductionCard.swift
//  TCM
//
//  Created by Shadow33 on 22/2/25.
//
import SwiftUI
import AVFAudio

struct IntroductionCard: View {
    var index: Int
    var title: String
    var description: String
    var imageName: String
    var isLastPage: Bool
    var startAction: () -> Void
    @EnvironmentObject private var audioManager: AudioManager
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(.secondary)
                
            Spacer()
            
            if isLastPage {
                Button(action: {
                    print("IntroductionCard: Start button pressed")
                    // Initialize audio session
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                        try AVAudioSession.sharedInstance().setActive(true)
                        print("Audio session initialized successfully")
                    } catch {
                        print("Failed to set up audio session: \(error)")
                    }
                    
                    startAction()
                    print("IntroductionCard: startAction completed")
                }) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(25)
                }
                .padding(.bottom, 50)
                .onAppear {
                    print("IntroductionCard: Last page appeared, isLastPage = \(isLastPage)")
                }
            }
        }
        .onAppear {
            print("IntroductionCard appeared: index = \(index), isLastPage = \(isLastPage)")
        }
    }
}
