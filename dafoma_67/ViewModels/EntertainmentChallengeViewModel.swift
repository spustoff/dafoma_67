//
//  EntertainmentChallengeViewModel.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import Foundation
import SwiftUI
import Combine

class EntertainmentChallengeViewModel: ObservableObject {
    @Published var challenges: [EntertainmentChallenge] = []
    @Published var selectedChallenge: EntertainmentChallenge?
    @Published var currentQuestion: ChallengeQuestion?
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswer: Int?
    @Published var showingResult = false
    @Published var isCorrect = false
    @Published var score = 0
    @Published var timeRemaining = 0
    @Published var isTimerActive = false
    @Published var challengeCompleted = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var leaderboard: [LeaderboardEntry] = []
    
    private let dataService = DataService.shared
    private let networkService = NetworkService.shared
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    
    init() {
        setupBindings()
        loadChallenges()
        loadLeaderboard()
    }
    
    private func setupBindings() {
        dataService.$entertainmentChallenges
            .receive(on: DispatchQueue.main)
            .assign(to: \.challenges, on: self)
            .store(in: &cancellables)
    }
    
    func loadChallenges() {
        isLoading = true
        
        networkService.fetchEntertainmentChallenges()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] challenges in
                    self?.challenges = challenges
                    self?.dataService.entertainmentChallenges = challenges
                    self?.dataService.saveEntertainmentChallenges()
                }
            )
            .store(in: &cancellables)
    }
    
    func loadLeaderboard() {
        networkService.fetchLeaderboard()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] leaderboard in
                    self?.leaderboard = leaderboard.sorted { $0.points > $1.points }
                }
            )
            .store(in: &cancellables)
    }
    
    func startChallenge(_ challenge: EntertainmentChallenge) {
        selectedChallenge = challenge
        currentQuestionIndex = 0
        score = 0
        challengeCompleted = false
        timeRemaining = challenge.timeLimit
        
        if !challenge.questions.isEmpty {
            currentQuestion = challenge.questions[0]
            startTimer()
        }
    }
    
    private func startTimer() {
        isTimerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timeUp()
            }
        }
    }
    
    private func stopTimer() {
        isTimerActive = false
        timer?.invalidate()
        timer = nil
    }
    
    func submitAnswer(_ answer: Int) {
        guard let question = currentQuestion else { return }
        
        selectedAnswer = answer
        isCorrect = answer == question.correctAnswer
        showingResult = true
        
        if isCorrect {
            score += calculateQuestionPoints()
        }
        
        stopTimer()
    }
    
    private func calculateQuestionPoints() -> Int {
        guard let challenge = selectedChallenge else { return 0 }
        
        let basePoints = challenge.points / challenge.questions.count
        let timeBonus = Int(Double(timeRemaining) / Double(challenge.timeLimit) * 50)
        
        return basePoints + timeBonus
    }
    
    func nextQuestion() {
        guard let challenge = selectedChallenge else { return }
        
        showingResult = false
        selectedAnswer = nil
        
        if currentQuestionIndex < challenge.questions.count - 1 {
            currentQuestionIndex += 1
            currentQuestion = challenge.questions[currentQuestionIndex]
            timeRemaining = challenge.timeLimit
            startTimer()
        } else {
            completeChallenge()
        }
    }
    
    private func timeUp() {
        stopTimer()
        showingResult = true
        isCorrect = false
        selectedAnswer = nil
    }
    
    func completeChallenge() {
        guard let challenge = selectedChallenge else { return }
        
        challengeCompleted = true
        stopTimer()
        
        // Save score to data service
        dataService.addChallengeScore(challengeId: challenge.id, score: score)
        
        // Refresh leaderboard
        loadLeaderboard()
    }
    
    func getChallengesByType(_ type: EntertainmentChallenge.ChallengeType) -> [EntertainmentChallenge] {
        return challenges.filter { $0.type == type }
    }
    
    func getChallengesByLanguage(_ language: String) -> [EntertainmentChallenge] {
        return challenges.filter { $0.language == language }
    }
    
    func getChallengesByDifficulty(_ difficulty: EntertainmentChallenge.DifficultyLevel) -> [EntertainmentChallenge] {
        return challenges.filter { $0.difficulty == difficulty }
    }
    
    func getAllChallengeTypes() -> [EntertainmentChallenge.ChallengeType] {
        return EntertainmentChallenge.ChallengeType.allCases
    }
    
    func getTypeIcon(_ type: EntertainmentChallenge.ChallengeType) -> String {
        switch type {
        case .movie:
            return "tv.fill"
        case .music:
            return "music.note"
        case .literature:
            return "book.fill"
        case .culture:
            return "globe.americas.fill"
        case .history:
            return "clock.fill"
        }
    }
    
    func getTypeColor(_ type: EntertainmentChallenge.ChallengeType) -> Color {
        switch type {
        case .movie:
            return .purple
        case .music:
            return .pink
        case .literature:
            return .brown
        case .culture:
            return .blue
        case .history:
            return .orange
        }
    }
    
    func getDifficultyColor(_ difficulty: EntertainmentChallenge.DifficultyLevel) -> Color {
        switch difficulty {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
    
    func getLanguageFlag(_ language: String) -> String {
        switch language.lowercased() {
        case "japanese":
            return "🇯🇵"
        case "french":
            return "🇫🇷"
        case "spanish":
            return "🇪🇸"
        case "german":
            return "🇩🇪"
        case "italian":
            return "🇮🇹"
        case "chinese":
            return "🇨🇳"
        case "korean":
            return "🇰🇷"
        default:
            return "🌍"
        }
    }
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    func resetChallenge() {
        selectedChallenge = nil
        currentQuestion = nil
        currentQuestionIndex = 0
        selectedAnswer = nil
        showingResult = false
        isCorrect = false
        score = 0
        timeRemaining = 0
        challengeCompleted = false
        stopTimer()
    }
    
    deinit {
        stopTimer()
    }
}
