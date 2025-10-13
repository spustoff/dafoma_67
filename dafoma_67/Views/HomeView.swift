//
//  HomeView.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var dataService = DataService.shared
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            LanguageCourseView()
                .tabItem {
                    Image(systemName: "globe.americas.fill")
                    Text("Courses")
                }
                .tag(1)
            
            BusinessSkillView()
                .tabItem {
                    Image(systemName: "briefcase.fill")
                    Text("Business")
                }
                .tag(2)
            
            EntertainmentChallengeView()
                .tabItem {
                    Image(systemName: "tv.fill")
                    Text("Challenges")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(Color("PrimaryGreen"))
    }
}

struct DashboardView: View {
    @StateObject private var dataService = DataService.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Welcome back!")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("DarkBlue").opacity(0.7))
                                
                                Text("Ready to learn?")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(Color("DarkBlue"))
                            }
                            
                            Spacer()
                            
                            // User level badge
                            VStack(spacing: 4) {
                                Text("Level")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color("DarkBlue").opacity(0.7))
                                
                                Text("\(dataService.userProgress.level)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color("PrimaryGreen"))
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.8))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        }
                        
                        // Progress to next level
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Progress to Level \(dataService.userProgress.level + 1)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color("DarkBlue"))
                                
                                Spacer()
                                
                                Text("\(Int(dataService.userProgress.nextLevelProgress * 100))%")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color("PrimaryGreen"))
                            }
                            
                            ProgressView(value: dataService.userProgress.nextLevelProgress)
                                .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryGreen")))
                                .scaleEffect(y: 2)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.6))
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Stats cards
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        StatCard(
                            title: "Total Points",
                            value: "\(dataService.userProgress.totalPoints)",
                            icon: "star.fill",
                            color: Color("PrimaryGreen")
                        )
                        
                        StatCard(
                            title: "Study Streak",
                            value: "\(dataService.userProgress.currentStreak) days",
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Courses",
                            value: "\(dataService.courses.count)",
                            icon: "globe.americas.fill",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Challenges",
                            value: "\(dataService.entertainmentChallenges.count)",
                            icon: "tv.fill",
                            color: .purple
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Recent courses
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Continue Learning")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color("DarkBlue"))
                            
                            Spacer()
                            
                            NavigationLink(destination: LanguageCourseView()) {
                                Text("View All")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color("PrimaryGreen"))
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(dataService.courses.prefix(3)) { course in
                                    CourseCard(course: course)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    // Quick actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color("DarkBlue"))
                            .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            QuickActionCard(
                                title: "Daily Challenge",
                                subtitle: "Test your skills",
                                icon: "target",
                                color: .red,
                                destination: AnyView(EntertainmentChallengeView())
                            )
                            
                            QuickActionCard(
                                title: "Business Skills",
                                subtitle: "Professional growth",
                                icon: "briefcase.fill",
                                color: Color("DarkBlue"),
                                destination: AnyView(BusinessSkillView())
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 20)
            }
            .background(Color("LightBackground").ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color("DarkBlue"))
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("DarkBlue").opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct CourseCard: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(course.flag)
                    .font(.system(size: 24))
                
                Spacer()
                
                Text(course.difficulty.rawValue)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(getDifficultyColor(course.difficulty))
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("DarkBlue"))
                    .lineLimit(2)
                
                Text(course.language)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("DarkBlue").opacity(0.7))
            }
            
            ProgressView(value: course.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryGreen")))
                .scaleEffect(y: 1.5)
        }
        .padding(16)
        .frame(width: 200)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private func getDifficultyColor(_ difficulty: Course.DifficultyLevel) -> Color {
        switch difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(color)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("DarkBlue").opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
}
