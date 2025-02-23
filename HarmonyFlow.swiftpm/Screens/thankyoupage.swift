import SwiftUI

struct ThankYouPage: View {
    let onDismiss: () -> Void
    @EnvironmentObject var workoutHistory: WorkoutHistory
    @EnvironmentObject var audioManager: AudioManager
    let stats: WorkoutStats
    @State private var showAnimation = false

    init(onDismiss: @escaping () -> Void, stats: WorkoutStats) {
        self.onDismiss = onDismiss
        self.stats = stats
    }

    private var formattedDuration: String {
        let minutes = stats.duration / 60
        let seconds = stats.duration % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                            .scaleEffect(showAnimation ? 1 : 0)
                    )
                    .offset(y: showAnimation ? 0 : -20)
                
                VStack(spacing: 15) {
                    Text("Great Work!")
                        .font(.title)
                        .fontWeight(.bold)
                        .opacity(showAnimation ? 1 : 0)
                        .offset(y: showAnimation ? 0 : 20)
                    
                    Text("You've completed your Qigong practice")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .opacity(showAnimation ? 1 : 0)
                        .offset(y: showAnimation ? 0 : 20)
                }
                
                VStack(spacing: 15) {
                    StatItem(
                        icon: "clock.fill",
                        text: "Practice Duration: \(formattedDuration)"
                    )
                    StatItem(
                        icon: "flame.fill",
                        text: "Movements Completed: \(stats.completedMovements)"
                    )
                }
                .padding(.top, 20)
                .opacity(showAnimation ? 1 : 0)
                .offset(y: showAnimation ? 0 : 20)
                
                Spacer()
                
                Button(action: {
                    audioManager.stopBackgroundMusic()
                    onDismiss()
                }) {
                    Text("Return to Home")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(25)
                }
                .padding(.bottom, 50)
                .opacity(showAnimation ? 1 : 0)
                .offset(y: showAnimation ? 0 : 20)
            }
        }
        .onAppear {
            workoutHistory.addWorkout(
                name: "Qigong Practice",
                duration: stats.duration,
                movements: stats.completedMovements
            )
            withAnimation(.spring().delay(0.3)) {
                showAnimation = true
            }
        }
    }
}

// MARK: - Stat Item Component
struct StatItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.system(size: 18))
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
    }
}
