//
//  SettingsView.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var dataService = DataService.shared
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @State private var showingResetAlert = false
    @State private var showingAbout = false
    
    let appVersion = "1.0.0"
    let buildNumber = "1"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // User profile section
                    VStack(spacing: 16) {
                        // Profile picture placeholder
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color("PrimaryGreen"), Color("PrimaryGreen").opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            
                            Text("LJ")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("LinguaLearn User")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color("DarkBlue"))
                            
                            Text("Level \(dataService.userProgress.level) • \(dataService.userProgress.totalPoints) points")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color("DarkBlue").opacity(0.7))
                        }
                        
                        // Progress to next level
                        VStack(spacing: 8) {
                            HStack {
                                Text("Progress to Level \(dataService.userProgress.level + 1)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color("DarkBlue").opacity(0.7))
                                
                                Spacer()
                                
                                Text("\(Int(dataService.userProgress.nextLevelProgress * 100))%")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color("PrimaryGreen"))
                            }
                            
                            ProgressView(value: dataService.userProgress.nextLevelProgress)
                                .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryGreen")))
                                .scaleEffect(y: 1.5)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Settings sections
                    VStack(spacing: 16) {
                        // Appearance
                        SettingsSection(title: "Appearance") {
                            SettingsRow(
                                title: "Dark Mode",
                                icon: "moon.fill",
                                iconColor: .purple
                            ) {
                                Toggle("", isOn: $isDarkMode)
                                    .labelsHidden()
                            }
                        }
                        
                        // Notifications & Sound
                        SettingsSection(title: "Notifications & Sound") {
                            
                            SettingsRow(
                                title: "Sound Effects",
                                icon: "speaker.wave.2.fill",
                                iconColor: .green
                            ) {
                                Toggle("", isOn: $soundEnabled)
                                    .labelsHidden()
                            }
                            
                            SettingsRow(
                                title: "Haptic Feedback",
                                icon: "iphone.radiowaves.left.and.right",
                                iconColor: .orange
                            ) {
                                Toggle("", isOn: $hapticFeedback)
                                    .labelsHidden()
                            }
                        }
                        
                        // Learning Preferences
                        SettingsSection(title: "Learning Preferences") {
                            
                            NavigationLink(destination: StudyGoalsView()) {
                                SettingsRow(
                                    title: "Study Goals",
                                    icon: "target",
                                    iconColor: .red
                                ) {
                                    HStack {
                                        Text("Daily")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color("DarkBlue").opacity(0.7))
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Color("DarkBlue").opacity(0.5))
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Account Management
                        SettingsSection(title: "Account") {
                            Button(action: { showingResetAlert = true }) {
                                SettingsRow(
                                    title: "Reset Progress",
                                    icon: "arrow.clockwise",
                                    iconColor: .red
                                ) {
                                    EmptyView()
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Support & Info
                        SettingsSection(title: "Support & Information") {
                            Button(action: { showingAbout = true }) {
                                SettingsRow(
                                    title: "About LinguaLearn",
                                    icon: "info.circle",
                                    iconColor: Color("DarkBlue")
                                ) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color("DarkBlue").opacity(0.5))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: HelpView()) {
                                SettingsRow(
                                    title: "Help & FAQ",
                                    icon: "questionmark.circle",
                                    iconColor: .purple
                                ) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color("DarkBlue").opacity(0.5))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // App version
                    VStack(spacing: 4) {
                        Text("LinguaLearn")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("DarkBlue"))
                        
                        Text("Version \(appVersion) (\(buildNumber))")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("DarkBlue").opacity(0.7))
                    }
                    .padding(.top, 16)
                }
                .padding(20)
            }
            .background(Color("LightBackground").ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Reset Progress", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    dataService.resetAllData()
                }
            } message: {
                Text("This will permanently delete all your progress, including completed courses, skills, and challenge scores. This action cannot be undone.")
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("DarkBlue"))
                .padding(.horizontal, 20)
            
            VStack(spacing: 1) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
            )
        }
    }
}

struct SettingsRow<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    let content: Content
    
    init(title: String, icon: String, iconColor: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("DarkBlue"))
            
            Spacer()
            
            content
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

struct LanguageSelectionView: View {
    @Binding var selectedLanguage: String
    @Environment(\.presentationMode) var presentationMode
    
    let availableLanguages = ["English", "Spanish", "French", "German", "Japanese", "Chinese", "Korean", "Italian"]
    
    var body: some View {
        List {
            ForEach(availableLanguages, id: \.self) { language in
                Button(action: {
                    selectedLanguage = language
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(language)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("DarkBlue"))
                        
                        Spacer()
                        
                        if selectedLanguage == language {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("PrimaryGreen"))
                        }
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationTitle("App Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudyGoalsView: View {
    @AppStorage("dailyGoalMinutes") private var dailyGoalMinutes = 15
    @AppStorage("weeklyGoalDays") private var weeklyGoalDays = 5
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Daily Study Goal")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("\(dailyGoalMinutes) minutes per day")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color("DarkBlue"))
                            
                            Spacer()
                        }
                        
                        Slider(value: Binding(
                            get: { Double(dailyGoalMinutes) },
                            set: { dailyGoalMinutes = Int($0) }
                        ), in: 5...60, step: 5)
                        .accentColor(Color("PrimaryGreen"))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                    )
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Weekly Study Goal")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("\(weeklyGoalDays) days per week")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color("DarkBlue"))
                            
                            Spacer()
                        }
                        
                        Slider(value: Binding(
                            get: { Double(weeklyGoalDays) },
                            set: { weeklyGoalDays = Int($0) }
                        ), in: 1...7, step: 1)
                        .accentColor(Color("PrimaryGreen"))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                    )
                }
            }
            .padding(20)
        }
        .background(Color("LightBackground").ignoresSafeArea())
        .navigationTitle("Study Goals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataExportView: View {
    @StateObject private var dataService = DataService.shared
    @State private var showingExportAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(Color("PrimaryGreen"))
                    
                    Text("Export Your Data")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    Text("Download a copy of your learning progress, including completed courses, skills, and challenge scores.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("DarkBlue").opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                VStack(spacing: 16) {
                    DataSummaryCard(
                        title: "Courses Completed",
                        value: "\(dataService.userProgress.completedCourses.count)",
                        icon: "globe.americas.fill",
                        color: .blue
                    )
                    
                    DataSummaryCard(
                        title: "Skills Mastered",
                        value: "\(dataService.userProgress.completedSkills.count)",
                        icon: "briefcase.fill",
                        color: Color("DarkBlue")
                    )
                    
                    DataSummaryCard(
                        title: "Total Points",
                        value: "\(dataService.userProgress.totalPoints)",
                        icon: "star.fill",
                        color: Color("PrimaryGreen")
                    )
                    
                    DataSummaryCard(
                        title: "Study Time",
                        value: "\(dataService.userProgress.studyTimeMinutes) min",
                        icon: "clock.fill",
                        color: .orange
                    )
                }
                
                Button(action: { showingExportAlert = true }) {
                    Text("Export Data")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("PrimaryGreen"))
                        )
                }
                .padding(.horizontal, 20)
            }
            .padding(20)
        }
        .background(Color("LightBackground").ignoresSafeArea())
        .navigationTitle("Export Data")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Export Complete", isPresented: $showingExportAlert) {
            Button("OK") { }
        } message: {
            Text("Your data has been exported successfully. Check your Files app for the exported data.")
        }
    }
}

struct DataSummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("DarkBlue").opacity(0.7))
                
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("DarkBlue"))
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
    }
}

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // App icon and title
                    VStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color("PrimaryGreen"), Color("PrimaryGreen").opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            
                            Text("LJ")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("LinguaLearn")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color("DarkBlue"))
                            
                            Text("Version 1.0.0")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color("DarkBlue").opacity(0.7))
                        }
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About LinguaLearn")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color("DarkBlue"))
                        
                        Text("LinguaLearn is an innovative educational application designed to enhance language learning while incorporating skills and knowledge from business and entertainment categories. It provides a unique and engaging way for users to learn new languages by integrating gamification, real-life scenarios, and interactive challenges.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color("DarkBlue").opacity(0.8))
                            .lineSpacing(4)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                    )
                    
                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Key Features")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color("DarkBlue"))
                        
                        VStack(spacing: 12) {
                            FeatureRow(
                                icon: "globe.americas.fill",
                                title: "Interactive Language Courses",
                                description: "Immersive courses with real-life conversational scenarios"
                            )
                            
                            FeatureRow(
                                icon: "briefcase.fill",
                                title: "Business Skills Integration",
                                description: "Professional communication and cultural etiquette training"
                            )
                            
                            FeatureRow(
                                icon: "tv.fill",
                                title: "Entertainment Challenges",
                                description: "Cultural quizzes based on movies, music, and literature"
                            )
                            
                            FeatureRow(
                                icon: "brain.head.profile.fill",
                                title: "Personalized Learning",
                                description: "AI-driven customization based on your progress and interests"
                            )
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                    )
                    
                    // Copyright
                    Text("© 2025 LinguaLearn. All rights reserved.")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("DarkBlue").opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                .padding(20)
            }
            .background(Color("LightBackground").ignoresSafeArea())
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color("PrimaryGreen"))
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color("PrimaryGreen"))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("DarkBlue"))
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("DarkBlue").opacity(0.7))
                    .lineSpacing(2)
            }
        }
    }
}

struct HelpView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Frequently Asked Questions")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("DarkBlue"))
                
                VStack(spacing: 16) {
                    FAQItem(
                        question: "How do I start learning a new language?",
                        answer: "Go to the Courses tab and select a language course that matches your skill level. Each course includes interactive lessons and exercises."
                    )
                    
                    FAQItem(
                        question: "What are Business Skills?",
                        answer: "Business Skills are specialized modules that teach professional communication and cultural etiquette for different languages and cultures."
                    )
                    
                    FAQItem(
                        question: "How do Entertainment Challenges work?",
                        answer: "Entertainment Challenges are timed quizzes based on movies, music, and cultural content. They help you learn about culture while practicing language skills."
                    )
                    
                    FAQItem(
                        question: "How is my progress tracked?",
                        answer: "Your progress is automatically saved as you complete lessons, exercises, and challenges. You can view your stats in the Settings tab."
                    )
                    
                    FAQItem(
                        question: "Can I reset my progress?",
                        answer: "Yes, you can reset all your progress in the Settings tab under Account > Reset Progress. This action cannot be undone."
                    )
                }
            }
            .padding(20)
        }
        .background(Color("LightBackground").ignoresSafeArea())
        .navigationTitle("Help & FAQ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(question)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("DarkBlue").opacity(0.7))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(answer)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("DarkBlue").opacity(0.8))
                    .lineSpacing(4)
                    .animation(.easeInOut(duration: 0.3), value: isExpanded)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("DarkBlue"))
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Data Collection")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    Text("LinguaLearn collects and stores your learning progress locally on your device. This includes completed courses, skill progress, challenge scores, and study statistics.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("DarkBlue").opacity(0.8))
                        .lineSpacing(4)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Data Usage")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    Text("Your data is used solely to provide personalized learning experiences and track your progress. We do not share your personal information with third parties.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("DarkBlue").opacity(0.8))
                        .lineSpacing(4)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Data Security")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    Text("All data is stored securely on your device using iOS security features. You can export or delete your data at any time through the Settings tab.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("DarkBlue").opacity(0.8))
                        .lineSpacing(4)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Contact")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    Text("If you have any questions about this Privacy Policy, please contact us through the app's support features.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("DarkBlue").opacity(0.8))
                        .lineSpacing(4)
                }
                
                Text("Last updated: October 13, 2025")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("DarkBlue").opacity(0.6))
                    .padding(.top, 20)
            }
            .padding(20)
        }
        .background(Color("LightBackground").ignoresSafeArea())
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
