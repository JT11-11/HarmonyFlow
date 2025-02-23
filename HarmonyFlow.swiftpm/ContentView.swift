import SwiftUI

struct ContentView: View {
    @State private var showPopup = false
    @State private var navigateToHome = false
    @StateObject private var workoutHistory = WorkoutHistory()
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, calendar, practice, progress
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if !navigateToHome {
                    LandingView(showPopup: $showPopup, navigateToHome: $navigateToHome)
                } else {
                    mainView
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.all)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(workoutHistory)
    }
    
    private var mainView: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeScreen(navigateToQiGong: {
                    withAnimation {
                        selectedTab = .practice
                    }
                })
            case .practice:
                QigongAppView(selectedTab: $selectedTab)
            case .calendar:
                ComingSoonScreen(
                    tabName: "Calendar",
                    icon: "calendar",
                    description: "We're working on a beautiful calendar to help you track and schedule your practices."
                )
                .padding(.bottom, 50)
            case .progress:
                ComingSoonScreen(
                    tabName: "Progress",
                    icon: "chart.bar.fill",
                    description: "Track your progress, view insights and celebrate your achievements."
                )
                .padding(.bottom, 50)
            }
            
            // Show tab bar except during practice
            if selectedTab != .practice {
                VStack {
                    Spacer()
                    customTabBar
                }
            }
        }
        .transition(.opacity)
    }
    
    // Landing view as a separate component
    private struct LandingView: View {
        @Binding var showPopup: Bool
        @Binding var navigateToHome: Bool
        
        var body: some View {
            ZStack {
                LandingScreen(showPopup: $showPopup)
                    .transition(.opacity)
                
                if showPopup {
                    VStack {
                        Spacer()
                        BottomPopup(
                            showPopup: $showPopup,
                            navigateToHome: $navigateToHome
                        )
                    }
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.spring()) {
                        showPopup = true
                    }
                }
            }
        }
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            TabBarItem(icon: "house.fill", text: "Home", isSelected: selectedTab == .home)
                .onTapGesture {
                    withAnimation {
                        selectedTab = .home
                    }
                }
            TabBarItem(icon: "calendar", text: "Calendar", isSelected: selectedTab == .calendar)
                .onTapGesture {
                    withAnimation {
                        selectedTab = .calendar
                    }
                }
            TabBarItem(icon: "figure.mind.and.body", text: "Practice", isSelected: selectedTab == .practice)
                .onTapGesture {
                    withAnimation {
                        selectedTab = .practice
                    }
                }
            TabBarItem(icon: "chart.bar.fill", text: "Progress", isSelected: selectedTab == .progress)
                .onTapGesture {
                    withAnimation {
                        selectedTab = .progress
                    }
                }
        }
        .padding(.vertical, 10)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -3)
    }
}

struct TabBarItem: View {
    let icon: String
    let text: String
    var isSelected: Bool = false
    
    let primaryColor = Color(red: 0.1, green: 0.5, blue: 0.4)
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(isSelected ? primaryColor : .gray)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? primaryColor : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}
