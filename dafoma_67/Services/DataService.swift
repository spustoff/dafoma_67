//
//  DataService.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import Foundation
import Combine

class DataService: ObservableObject {
    static let shared = DataService()
    
    @Published var courses: [Course] = []
    @Published var businessSkills: [BusinessSkill] = []
    @Published var entertainmentChallenges: [EntertainmentChallenge] = []
    @Published var userProgress: UserProgress = UserProgress()
    
    private let userDefaults = UserDefaults.standard
    private let coursesKey = "saved_courses"
    private let skillsKey = "saved_skills"
    private let challengesKey = "saved_challenges"
    private let progressKey = "user_progress"
    
    private init() {
        loadData()
    }
    
    // MARK: - Data Loading
    func loadData() {
        loadCourses()
        loadBusinessSkills()
        loadEntertainmentChallenges()
        loadUserProgress()
    }
    
    private func loadCourses() {
        if let data = userDefaults.data(forKey: coursesKey),
           let savedCourses = try? JSONDecoder().decode([Course].self, from: data) {
            self.courses = savedCourses
        } else {
            self.courses = Course.sampleCourses
            saveCourses()
        }
    }
    
    private func loadBusinessSkills() {
        if let data = userDefaults.data(forKey: skillsKey),
           let savedSkills = try? JSONDecoder().decode([BusinessSkill].self, from: data) {
            self.businessSkills = savedSkills
        } else {
            self.businessSkills = BusinessSkill.sampleSkills
            saveBusinessSkills()
        }
    }
    
    private func loadEntertainmentChallenges() {
        if let data = userDefaults.data(forKey: challengesKey),
           let savedChallenges = try? JSONDecoder().decode([EntertainmentChallenge].self, from: data) {
            self.entertainmentChallenges = savedChallenges
        } else {
            self.entertainmentChallenges = EntertainmentChallenge.sampleChallenges
            saveEntertainmentChallenges()
        }
    }
    
    private func loadUserProgress() {
        if let data = userDefaults.data(forKey: progressKey),
           let savedProgress = try? JSONDecoder().decode(UserProgress.self, from: data) {
            self.userProgress = savedProgress
        } else {
            self.userProgress = UserProgress()
            saveUserProgress()
        }
    }
    
    // MARK: - Data Saving
    func saveCourses() {
        if let data = try? JSONEncoder().encode(courses) {
            userDefaults.set(data, forKey: coursesKey)
        }
    }
    
    func saveBusinessSkills() {
        if let data = try? JSONEncoder().encode(businessSkills) {
            userDefaults.set(data, forKey: skillsKey)
        }
    }
    
    func saveEntertainmentChallenges() {
        if let data = try? JSONEncoder().encode(entertainmentChallenges) {
            userDefaults.set(data, forKey: challengesKey)
        }
    }
    
    func saveUserProgress() {
        if let data = try? JSONEncoder().encode(userProgress) {
            userDefaults.set(data, forKey: progressKey)
        }
    }
    
    // MARK: - Progress Management
    func updateCourseProgress(courseId: UUID, progress: Double) {
        if let index = courses.firstIndex(where: { $0.id == courseId }) {
            courses[index] = Course(
                title: courses[index].title,
                language: courses[index].language,
                description: courses[index].description,
                difficulty: courses[index].difficulty,
                lessons: courses[index].lessons,
                progress: progress,
                estimatedTime: courses[index].estimatedTime,
                flag: courses[index].flag
            )
            saveCourses()
        }
    }
    
    func updateSkillProgress(skillId: UUID, progress: Double) {
        if let index = businessSkills.firstIndex(where: { $0.id == skillId }) {
            businessSkills[index] = BusinessSkill(
                title: businessSkills[index].title,
                category: businessSkills[index].category,
                description: businessSkills[index].description,
                modules: businessSkills[index].modules,
                progress: progress,
                estimatedTime: businessSkills[index].estimatedTime,
                icon: businessSkills[index].icon
            )
            saveBusinessSkills()
        }
    }
    
    func addChallengeScore(challengeId: UUID, score: Int) {
        userProgress.challengeScores[challengeId] = score
        userProgress.totalPoints += score
        saveUserProgress()
    }
    
    // MARK: - Reset Functionality
    func resetAllData() {
        userDefaults.removeObject(forKey: coursesKey)
        userDefaults.removeObject(forKey: skillsKey)
        userDefaults.removeObject(forKey: challengesKey)
        userDefaults.removeObject(forKey: progressKey)
        
        courses = Course.sampleCourses
        businessSkills = BusinessSkill.sampleSkills
        entertainmentChallenges = EntertainmentChallenge.sampleChallenges
        userProgress = UserProgress()
        
        saveCourses()
        saveBusinessSkills()
        saveEntertainmentChallenges()
        saveUserProgress()
    }
}

// MARK: - User Progress Model
struct UserProgress: Codable {
    var totalPoints: Int = 0
    var challengeScores: [UUID: Int] = [:]
    var completedCourses: [UUID] = []
    var completedSkills: [UUID] = []
    var currentStreak: Int = 0
    var lastStudyDate: Date = Date()
    var studyTimeMinutes: Int = 0
    
    var level: Int {
        return totalPoints / 1000 + 1
    }
    
    var nextLevelProgress: Double {
        let currentLevelPoints = (level - 1) * 1000
        let nextLevelPoints = level * 1000
        let progressPoints = totalPoints - currentLevelPoints
        return Double(progressPoints) / Double(nextLevelPoints - currentLevelPoints)
    }
}
