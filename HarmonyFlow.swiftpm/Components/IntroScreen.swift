//
//  IntroScreen.swift
//  TCM
//
//  Created by Shadow33 on 23/2/25.
//
import SwiftUI
import AVFAudio

struct PracticeScreen: View {
    var onStartExercise: () -> Void
    @EnvironmentObject private var audioManager: AudioManager
    @State private var currentPage = 0
    
    // Your introduction pages data
    private let introPages = [
        (title: "Welcome to Qigong", description: "Begin your journey to wellness through ancient Chinese practices", image: "heart.circle.fill"),
        (title: "Mindful Movement", description: "Connect your body and mind through gentle, flowing exercises", image: "figure.walk.circle.fill"),
        (title: "Begin Practice", description: "Ready to start your Qigong journey?", image: "sun.max.circle.fill")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<introPages.count) { index in
                    IntroductionCard(
                        index: index,
                        title: introPages[index].title,
                        description: introPages[index].description,
                        imageName: introPages[index].image,
                        isLastPage: index == introPages.count - 1,
                        startAction: {
                            print("PracticeScreen: Start action triggered")
                            do {
                                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                                try AVAudioSession.sharedInstance().setActive(true)
                                print("Audio session initialized successfully")
                                onStartExercise()
                            } catch {
                                print("Failed to set up audio session: \(error)")
                            }
                        }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
