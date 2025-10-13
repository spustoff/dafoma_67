//
//  BusinessSkillViewModel.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import Foundation
import SwiftUI
import Combine

class BusinessSkillViewModel: ObservableObject {
    @Published var businessSkills: [BusinessSkill] = []
    @Published var selectedSkill: BusinessSkill?
    @Published var currentModule: SkillModule?
    @Published var currentScenario: PracticeScenario?
    @Published var moduleProgress: Double = 0.0
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingScenarioDetail = false
    @Published var completedScenarios: Set<UUID> = []
    
    private let dataService = DataService.shared
    private let networkService = NetworkService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        loadBusinessSkills()
    }
    
    private func setupBindings() {
        dataService.$businessSkills
            .receive(on: DispatchQueue.main)
            .assign(to: \.businessSkills, on: self)
            .store(in: &cancellables)
    }
    
    func loadBusinessSkills() {
        isLoading = true
        
        networkService.fetchBusinessSkills()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] skills in
                    self?.businessSkills = skills
                    self?.dataService.businessSkills = skills
                    self?.dataService.saveBusinessSkills()
                }
            )
            .store(in: &cancellables)
    }
    
    func selectSkill(_ skill: BusinessSkill) {
        selectedSkill = skill
        if let firstModule = skill.modules.first {
            startModule(firstModule)
        }
    }
    
    func startModule(_ module: SkillModule) {
        currentModule = module
        moduleProgress = 0.0
        completedScenarios.removeAll()
    }
    
    func selectScenario(_ scenario: PracticeScenario) {
        currentScenario = scenario
        showingScenarioDetail = true
    }
    
    func completeScenario(_ scenario: PracticeScenario) {
        completedScenarios.insert(scenario.id)
        
        // Update module progress
        if let module = currentModule {
            let progress = Double(completedScenarios.count) / Double(module.practiceScenarios.count)
            moduleProgress = progress
            
            // If all scenarios completed, update skill progress
            if progress >= 1.0 {
                completeModule()
            }
        }
    }
    
    func completeModule() {
        guard let skill = selectedSkill else { return }
        
        // Update skill progress
        let newProgress = min(skill.progress + (1.0 / Double(skill.modules.count)), 1.0)
        dataService.updateSkillProgress(skillId: skill.id, progress: newProgress)
        
        // Add points to user progress
        let points = calculateModulePoints()
        dataService.userProgress.totalPoints += points
        dataService.saveUserProgress()
    }
    
    private func calculateModulePoints() -> Int {
        guard let module = currentModule else { return 0 }
        return module.duration * 2 // 2 points per minute
    }
    
    func getSkillsByCategory(_ category: BusinessSkill.SkillCategory) -> [BusinessSkill] {
        return businessSkills.filter { $0.category == category }
    }
    
    func getAllCategories() -> [BusinessSkill.SkillCategory] {
        return BusinessSkill.SkillCategory.allCases
    }
    
    func getCategoryIcon(_ category: BusinessSkill.SkillCategory) -> String {
        switch category {
        case .communication:
            return "bubble.left.and.bubble.right.fill"
        case .negotiation:
            return "handshake.fill"
        case .presentation:
            return "person.3.fill"
        case .networking:
            return "network"
        case .leadership:
            return "crown.fill"
        case .etiquette:
            return "graduationcap.fill"
        }
    }
    
    func getCategoryColor(_ category: BusinessSkill.SkillCategory) -> Color {
        switch category {
        case .communication:
            return .blue
        case .negotiation:
            return .green
        case .presentation:
            return .purple
        case .networking:
            return .orange
        case .leadership:
            return .red
        case .etiquette:
            return Color(red: 0.714, green: 0.875, blue: 0.082) // #B6DF15
        }
    }
    
    func getProgressColor(for progress: Double) -> Color {
        switch progress {
        case 0.0..<0.3:
            return .red
        case 0.3..<0.7:
            return .orange
        default:
            return Color(red: 0.714, green: 0.875, blue: 0.082) // #B6DF15
        }
    }
    
    func formatDuration(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if remainingMinutes == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(remainingMinutes)m"
            }
        }
    }
    
    func getLanguageFlag(_ language: String) -> String {
        switch language.lowercased() {
        case "japanese":
            return "🇯🇵"
        case "german":
            return "🇩🇪"
        case "french":
            return "🇫🇷"
        case "spanish":
            return "🇪🇸"
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
    
    func resetProgress() {
        selectedSkill = nil
        currentModule = nil
        currentScenario = nil
        moduleProgress = 0.0
        showingScenarioDetail = false
        completedScenarios.removeAll()
    }
}
