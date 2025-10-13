//
//  EntertainmentChallengeView.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import SwiftUI

struct EntertainmentChallengeView: View {
    @StateObject private var viewModel = EntertainmentChallengeViewModel()
    @State private var selectedType: EntertainmentChallenge.ChallengeType?
    @State private var selectedDifficulty: EntertainmentChallenge.DifficultyLevel?
    @State private var showingFilters = false
    @State private var showingLeaderboard = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("LightBackground").ignoresSafeArea()
                
                if viewModel.selectedChallenge != nil {
                    ChallengeGameView(viewModel: viewModel)
                } else {
                    challengeListView
                }
            }
            .navigationTitle("Entertainment Challenges")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingLeaderboard.toggle() }) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(Color("PrimaryGreen"))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(Color("PrimaryGreen"))
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                ChallengeFilterView(
                    selectedType: $selectedType,
                    selectedDifficulty: $selectedDifficulty
                )
            }
            .sheet(isPresented: $showingLeaderboard) {
                LeaderboardView(viewModel: viewModel)
            }
        }
    }
    
    private var challengeListView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // User stats
                HStack(spacing: 16) {
                    StatBadge(
                        title: "Total Points",
                        value: "\(DataService.shared.userProgress.totalPoints)",
                        icon: "star.fill",
                        color: Color("PrimaryGreen")
                    )
                    
                    StatBadge(
                        title: "Challenges",
                        value: "\(filteredChallenges.count)",
                        icon: "tv.fill",
                        color: Color("DarkBlue")
                    )
                }
                .padding(.horizontal, 20)
                
                // Challenge types
                VStack(alignment: .leading, spacing: 16) {
                    Text("Challenge Types")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.getAllChallengeTypes(), id: \.self) { type in
                                ChallengeTypeCard(
                                    type: type,
                                    isSelected: selectedType == type,
                                    icon: viewModel.getTypeIcon(type),
                                    color: viewModel.getTypeColor(type)
                                ) {
                                    selectedType = selectedType == type ? nil : type
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                // Challenges grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 16) {
                    ForEach(filteredChallenges) { challenge in
                        ChallengeCard(challenge: challenge, viewModel: viewModel) {
                            viewModel.startChallenge(challenge)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
        .refreshable {
            viewModel.loadChallenges()
        }
    }
    
    private var filteredChallenges: [EntertainmentChallenge] {
        var challenges = viewModel.challenges
        
        if let type = selectedType {
            challenges = challenges.filter { $0.type == type }
        }
        
        if let difficulty = selectedDifficulty {
            challenges = challenges.filter { $0.difficulty == difficulty }
        }
        
        return challenges
    }
}

struct ChallengeTypeCard: View {
    let type: EntertainmentChallenge.ChallengeType
    let isSelected: Bool
    let icon: String
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : color)
                
                Text(type.rawValue)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isSelected ? .white : Color("DarkBlue"))
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? color : Color.white.opacity(0.8))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ChallengeCard: View {
    let challenge: EntertainmentChallenge
    let viewModel: EntertainmentChallengeViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    HStack(spacing: 8) {
                        Text(viewModel.getLanguageFlag(challenge.language))
                            .font(.system(size: 20))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(challenge.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("DarkBlue"))
                                .multilineTextAlignment(.leading)
                            
                            Text(challenge.language)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color("DarkBlue").opacity(0.7))
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("\(challenge.points)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color("PrimaryGreen"))
                        
                        Text("points")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color("DarkBlue").opacity(0.7))
                    }
                }
                
                // Description
                Text(challenge.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("DarkBlue").opacity(0.8))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Challenge info
                HStack {
                    Label("\(challenge.questions.count) questions", systemImage: "questionmark.circle")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("DarkBlue").opacity(0.6))
                    
                    Spacer()
                    
                    Label(viewModel.formatTime(challenge.timeLimit), systemImage: "clock")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("DarkBlue").opacity(0.6))
                    
                    Spacer()
                    
                    Text(challenge.difficulty.rawValue)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(viewModel.getDifficultyColor(challenge.difficulty))
                        )
                }
                
                // Media reference
                if let media = challenge.mediaReference {
                    HStack {
                        Image(systemName: viewModel.getTypeIcon(challenge.type))
                            .font(.system(size: 14))
                            .foregroundColor(viewModel.getTypeColor(challenge.type))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(media.title)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color("DarkBlue"))
                            
                            Text(media.creator)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color("DarkBlue").opacity(0.7))
                        }
                        
                        Spacer()
                        
                        if let year = media.year {
                            Text("\(year)")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color("DarkBlue").opacity(0.7))
                        }
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.getTypeColor(challenge.type).opacity(0.1))
                    )
                }
            }
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

struct ChallengeGameView: View {
    @ObservedObject var viewModel: EntertainmentChallengeViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.challengeCompleted {
                ChallengeResultView(viewModel: viewModel)
            } else {
                // Game header
                VStack(spacing: 12) {
                    HStack {
                        Button(action: { viewModel.resetChallenge() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color("DarkBlue"))
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("Score: \(viewModel.score)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color("PrimaryGreen"))
                            
                            Text(viewModel.formatTime(viewModel.timeRemaining))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(viewModel.timeRemaining < 30 ? .red : Color("DarkBlue"))
                        }
                    }
                    
                    if let challenge = viewModel.selectedChallenge {
                        ProgressView(value: Double(viewModel.currentQuestionIndex + 1) / Double(challenge.questions.count))
                            .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryGreen")))
                            .scaleEffect(y: 2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.9))
                
                // Question content
                ScrollView {
                    VStack(spacing: 24) {
                        if let question = viewModel.currentQuestion {
                            VStack(spacing: 20) {
                                // Question number and text
                                VStack(spacing: 12) {
                                    Text("Question \(viewModel.currentQuestionIndex + 1)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color("DarkBlue").opacity(0.7))
                                    
                                    Text(question.question)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Color("DarkBlue"))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                }
                                
                                // Answer options
                                VStack(spacing: 12) {
                                    ForEach(0..<question.options.count, id: \.self) { index in
                                        ChallengeOptionButton(
                                            text: question.options[index],
                                            isSelected: viewModel.selectedAnswer == index,
                                            isCorrect: viewModel.showingResult && index == question.correctAnswer,
                                            isWrong: viewModel.showingResult && viewModel.selectedAnswer == index && index != question.correctAnswer,
                                            showingResult: viewModel.showingResult
                                        ) {
                                            if !viewModel.showingResult {
                                                viewModel.submitAnswer(index)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                // Result explanation
                                if viewModel.showingResult {
                                    VStack(spacing: 12) {
                                        HStack {
                                            Image(systemName: viewModel.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(viewModel.isCorrect ? .green : .red)
                                            
                                            Text(viewModel.isCorrect ? "Correct!" : "Incorrect")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(viewModel.isCorrect ? .green : .red)
                                            
                                            Spacer()
                                        }
                                        
                                        Text(question.explanation)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(Color("DarkBlue").opacity(0.8))
                                            .multilineTextAlignment(.leading)
                                        
                                        if let culturalNote = question.culturalNote {
                                            HStack(alignment: .top, spacing: 8) {
                                                Image(systemName: "info.circle.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.blue)
                                                    .padding(.top, 2)
                                                
                                                Text(culturalNote)
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundColor(Color("DarkBlue").opacity(0.7))
                                                    .multilineTextAlignment(.leading)
                                            }
                                        }
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.8))
                                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                                    )
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 24)
                }
                .background(Color("LightBackground").ignoresSafeArea())
                
                // Next button
                if viewModel.showingResult {
                    Button(action: viewModel.nextQuestion) {
                        Text("Continue")
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
                    .padding(.bottom, 32)
                    .background(Color.white.opacity(0.9))
                }
            }
        }
    }
}

struct ChallengeOptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let showingResult: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if showingResult {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if isWrong {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        if showingResult {
            if isCorrect {
                return .green.opacity(0.1)
            } else if isWrong {
                return .red.opacity(0.1)
            }
        }
        return isSelected ? Color("PrimaryGreen").opacity(0.1) : Color.white.opacity(0.8)
    }
    
    private var borderColor: Color {
        if showingResult {
            if isCorrect {
                return .green
            } else if isWrong {
                return .red
            }
        }
        return isSelected ? Color("PrimaryGreen") : Color.clear
    }
    
    private var textColor: Color {
        if showingResult {
            if isCorrect {
                return .green
            } else if isWrong {
                return .red
            }
        }
        return Color("DarkBlue")
    }
}

struct ChallengeResultView: View {
    @ObservedObject var viewModel: EntertainmentChallengeViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Result icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color("PrimaryGreen"), Color("PrimaryGreen").opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // Score and stats
            VStack(spacing: 16) {
                Text("Challenge Complete!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("DarkBlue"))
                
                Text("Final Score: \(viewModel.score)")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color("PrimaryGreen"))
                
                if let challenge = viewModel.selectedChallenge {
                    Text("You answered \(viewModel.currentQuestionIndex + 1) out of \(challenge.questions.count) questions")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("DarkBlue").opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 16) {
                Button(action: { viewModel.resetChallenge() }) {
                    Text("Try Another Challenge")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("PrimaryGreen"))
                        )
                }
                
                Button(action: { viewModel.resetChallenge() }) {
                    Text("Back to Challenges")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("DarkBlue"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("DarkBlue").opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(Color("LightBackground").ignoresSafeArea())
    }
}

struct LeaderboardView: View {
    @ObservedObject var viewModel: EntertainmentChallengeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(viewModel.leaderboard.enumerated()), id: \.element.id) { index, entry in
                        LeaderboardRow(entry: entry, rank: index + 1)
                    }
                }
                .padding(20)
            }
            .background(Color("LightBackground").ignoresSafeArea())
            .navigationTitle("Leaderboard")
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
        .onAppear {
            viewModel.loadLeaderboard()
        }
    }
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    let rank: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            ZStack {
                Circle()
                    .fill(rankColor)
                    .frame(width: 32, height: 32)
                
                Text("\(rank)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.username)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("DarkBlue"))
                
                Text("Level \(entry.level)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("DarkBlue").opacity(0.7))
            }
            
            Spacer()
            
            // Points
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.points)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color("PrimaryGreen"))
                
                Text("points")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color("DarkBlue").opacity(0.7))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(entry.username == "You" ? Color("PrimaryGreen").opacity(0.1) : Color.white.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(entry.username == "You" ? Color("PrimaryGreen") : Color.clear, lineWidth: 2)
                )
        )
    }
    
    private var rankColor: Color {
        switch rank {
        case 1:
            return .yellow
        case 2:
            return .gray
        case 3:
            return .brown
        default:
            return Color("DarkBlue")
        }
    }
}

struct ChallengeFilterView: View {
    @Binding var selectedType: EntertainmentChallenge.ChallengeType?
    @Binding var selectedDifficulty: EntertainmentChallenge.DifficultyLevel?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Challenge Type")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(EntertainmentChallenge.ChallengeType.allCases, id: \.self) { type in
                            FilterChip(
                                title: type.rawValue,
                                isSelected: selectedType == type
                            ) {
                                selectedType = selectedType == type ? nil : type
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Difficulty Level")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    HStack(spacing: 12) {
                        ForEach(EntertainmentChallenge.DifficultyLevel.allCases, id: \.self) { difficulty in
                            FilterChip(
                                title: difficulty.rawValue,
                                isSelected: selectedDifficulty == difficulty
                            ) {
                                selectedDifficulty = selectedDifficulty == difficulty ? nil : difficulty
                            }
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                
                Button("Clear All Filters") {
                    selectedType = nil
                    selectedDifficulty = nil
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("DarkBlue"))
            }
            .padding(20)
            .navigationTitle("Filter Challenges")
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

#Preview {
    EntertainmentChallengeView()
}
