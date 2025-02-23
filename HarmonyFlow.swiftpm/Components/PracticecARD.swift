import SwiftUI
import Combine
import AVFoundation
import AVFAudio

// MARK: - WorkoutStats Structure
struct WorkoutStats {
    var duration: Int
    var completedMovements: Int
}

// MARK: - Audio Manager
@MainActor
class AudioManager: ObservableObject {
    private var player: AVAudioPlayer?
    @Published var isPlaying: Bool = false
    
    init() {
        setupAudio()
    }
    
    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ Audio session configured")
        } catch {
            print("❌ Failed to configure audio session: \(error.localizedDescription)")
        }
    }
    
    func loadAudio() {
        if let url = Bundle.main.url(forResource: "mediation", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = 4
                player?.prepareToPlay()
                print("✅ Audio player initialized")
            } catch {
                print("❌ Failed to create audio player: \(error)")
            }
        } else {
            print("❌ Failed to find mediation.mp3")
        }
    }
    
    func startBackgroundMusic() {
        if player == nil { loadAudio() }
        guard let player = player else { return }
        
        player.currentTime = 0
        player.play()
        isPlaying = true
        print("🎵 Started music")
    }
    
    func stopBackgroundMusic() {
        guard let player = player else { return }
        player.stop()
        player.currentTime = 0
        self.player?.stop()
        self.player = nil
        isPlaying = false
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            print("⏹️ Music stopped and session deactivated")
        } catch {
            print("❌ Failed to deactivate audio session: \(error)")
        }
    }
}

// MARK: - Exercise Component
struct QigongExerciseComponent: View {
    let exerciseName: String
    let exerciseDescription: String
    let exerciseImageName: String
    let onComplete: () -> Void
    let onEndWorkout: () -> Void

    @State private var timeRemaining: Int = 30
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var timerConnected: Cancellable? = nil
    @State private var isActive: Bool = true
    @EnvironmentObject var audioManager: AudioManager

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 15)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)

                    Circle()
                        .trim(from: 0.0, to: CGFloat(timeRemaining) / 30.0)
                        .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                        .foregroundColor(timeRemaining > 10 ? Color.green : Color.red)
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.linear, value: timeRemaining)

                    Text("\(timeRemaining)")
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                        .foregroundColor(timeRemaining > 10 ? .primary : .red)
                }
                .frame(width: 200, height: 200)
                .padding(.top, 40)

                Image(exerciseImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .padding()

                VStack(spacing: 10) {
                    Text(exerciseName)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(exerciseDescription)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }

                Spacer()
                
                Button(action: {
                    isActive = false
                    stopExercise()
                    onEndWorkout()
                }) {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                        Text("End")
                    }
                    .font(.headline)
                    .padding()
                    .frame(width: 140)
                    .background(Color.red.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startExercise()
        }
        .onDisappear {
            stopExercise()
        }
        .onReceive(timer) { _ in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining == 0 {
                    stopExercise()
                    onComplete()
                }
            }
        }
    }

    private func startExercise() {
        isActive = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
        timerConnected = timer.connect()
        audioManager.startBackgroundMusic()
    }

    private func stopExercise() {
        timerConnected?.cancel()
        timerConnected = nil
        audioManager.stopBackgroundMusic()
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 100_000_000)
            audioManager.stopBackgroundMusic()
        }
    }
}

// MARK: - Workout Session
struct QigongWorkoutSession: View {
    @State private var currentExerciseIndex = 0
    @State private var showingExercise = true
    @EnvironmentObject var workoutHistory: WorkoutHistory
    @State private var showingThankYou = false
    @State private var workoutStats = WorkoutStats(duration: 0, completedMovements: 0)
    @State private var workoutTimer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var workoutTimerConnected: Cancellable? = nil
    @State private var isWorkoutActive: Bool = true
    @StateObject private var audioManager = AudioManager()
    
    let onFinish: () -> Void
    
    let exercises = [
        (name: "Standing Like a Tree", description: "Stand with your feet shoulder-width apart, knees slightly bent, arms raised as if hugging a tree", image: "qigong_tree_pose"),
        (name: "Pushing the Mountain", description: "Push your palms forward slowly with intent, then pull back toward your chest", image: "qigong_push_mountain"),
        (name: "Gathering Qi", description: "With palms facing up, slowly raise your hands from lower abdomen to chest level", image: "qigong_gather_qi"),
        (name: "Washing with Qi", description: "Move your hands down the front of your body as if washing with energy", image: "qigong_washing")
    ]
    
    var body: some View {
        Group {
            if showingThankYou {
                ThankYouPage(
                    onDismiss: {
                        isWorkoutActive = false
                        stopWorkoutTimer()
                        audioManager.stopBackgroundMusic()
                        onFinish()
                    },
                    stats: workoutStats
                )
                .environmentObject(audioManager)
                .onAppear {
                    isWorkoutActive = false
                    stopWorkoutTimer()           
                }
            } else if showingExercise {
                QigongExerciseComponent(
                    exerciseName: exercises[currentExerciseIndex].name,
                    exerciseDescription: exercises[currentExerciseIndex].description,
                    exerciseImageName: exercises[currentExerciseIndex].image,
                    onComplete: {
                        handleExerciseComplete()
                    },
                    onEndWorkout: {
                        isWorkoutActive = false  // Stop timer updates
                        stopWorkoutTimer()       // Cancel timer
                        audioManager.stopBackgroundMusic()
                        workoutStats.completedMovements = currentExerciseIndex + 1
                        showingThankYou = true
                    }
                )
                .environmentObject(audioManager)
            } else {
                VStack {
                    Text("Prepare for next exercise")
                        .font(.headline)
                    ProgressView()
                }
                .onAppear {
                    audioManager.stopBackgroundMusic()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showingExercise = true
                    }
                }
            }
        }
        .onAppear {
            isWorkoutActive = true
            startWorkoutTimer()
        }
        .onDisappear {
            isWorkoutActive = false
            stopWorkoutTimer()
            audioManager.stopBackgroundMusic()
        }
        .onReceive(workoutTimer) { _ in
            guard isWorkoutActive else { return }
            workoutStats.duration += 1
        }
    }
    
    private func startWorkoutTimer() {
        workoutTimer = Timer.publish(every: 1, on: .main, in: .common)
        workoutTimerConnected = workoutTimer.connect()
    }
    
    private func stopWorkoutTimer() {
        workoutTimerConnected?.cancel()
        workoutTimerConnected = nil
        print("⏹️ Workout timer stopped")
    }
    
    func handleExerciseComplete() {
        if currentExerciseIndex < exercises.count - 1 {
            workoutStats.completedMovements += 1
            showingExercise = false
            audioManager.stopBackgroundMusic()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                currentExerciseIndex += 1
                showingExercise = true
            }
        } else {
            workoutStats.completedMovements = exercises.count
            isWorkoutActive = false
            stopWorkoutTimer()             
            audioManager.stopBackgroundMusic()
            showingThankYou = true
        }
    }
}
