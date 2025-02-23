import SwiftUI

struct WorkoutRecord: Identifiable {
    let id = UUID()
    let name: String
    let completedDate: Date
    let duration: Int
    let movementsCompleted: Int
    
    var lastPracticedText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return "Last practiced " + formatter.localizedString(for: completedDate, relativeTo: Date())
    }
}

// Observable workout history manager
class WorkoutHistory: ObservableObject {
    @Published var workouts: [WorkoutRecord] = []
    
    func addWorkout(name: String, duration: Int, movements: Int) {
        let newWorkout = WorkoutRecord(
            name: name,
            completedDate: Date(),
            duration: duration,
            movementsCompleted: movements
        )
        workouts.append(newWorkout)
    }
    
    func getRecentWorkouts() -> [WorkoutRecord] {
        return workouts.sorted { $0.completedDate > $1.completedDate }
    }
}

struct RecentPracticeRow: View {
    let workout: WorkoutRecord
    
    private var formattedDuration: String {
        let minutes = workout.duration / 60
        let seconds = workout.duration % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "figure.mind.and.body")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.1, green: 0.5, blue: 0.4))
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(workout.name)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                
                Text(workout.lastPracticedText)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Duration: \(formattedDuration)")
                    Text("•")
                    Text("Movements: \(workout.movementsCompleted)")
                }
                .font(.system(size: 12))
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "play.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color(red: 0.1, green: 0.5, blue: 0.4))
                    )
            }
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
