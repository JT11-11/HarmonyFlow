//
//  PracticeScreen.swift
//  TCM
//
//  Created by Shadow33 on 20/2/25.
//
import SwiftUI
import Combine
import AVFoundation
import AVFAudio

enum AppScreen {
    case practice
    case exerciseSession
}

// MARK: - Main App View
struct QigongAppView: View {
    @State private var currentScreen: AppScreen = .practice
    @Binding var selectedTab: ContentView.Tab
    @EnvironmentObject var workoutHistory: WorkoutHistory
    @StateObject private var audioManager = AudioManager()

    var body: some View {
        NavigationView {
            Group {
                switch currentScreen {
                case .practice:
                    PracticeScreen(onStartExercise: {
                        withAnimation(.easeInOut) {
                            currentScreen = .exerciseSession
                        }
                    })
                    .environmentObject(audioManager)

                case .exerciseSession:
                    QigongWorkoutSession(onFinish: {
                        withAnimation {
                            selectedTab = .home
                            audioManager.stopBackgroundMusic()
                        }
                    })
                    .environmentObject(audioManager)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
                .onDisappear {
                    audioManager.stopBackgroundMusic()
                }
            }
        }
