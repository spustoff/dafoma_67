//
//  LanguageCourseViewModel.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import Foundation
import SwiftUI
import Combine

class LanguageCourseViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var selectedCourse: Course?
    @Published var currentLesson: Lesson?
    @Published var currentExercise: Exercise?
    @Published var currentExerciseIndex = 0
    @Published var selectedAnswer: Int?
    @Published var showingResult = false
    @Published var isCorrect = false
    @Published var lessonProgress: Double = 0.0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dataService = DataService.shared
    private let networkService = NetworkService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        loadCourses()
    }
    
    private func setupBindings() {
        dataService.$courses
            .receive(on: DispatchQueue.main)
            .assign(to: \.courses, on: self)
            .store(in: &cancellables)
    }
    
    func loadCourses() {
        isLoading = true
        
        networkService.fetchLatestCourses()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] courses in
                    self?.courses = courses
                    self?.dataService.courses = courses
                    self?.dataService.saveCourses()
                }
            )
            .store(in: &cancellables)
    }
    
    func selectCourse(_ course: Course) {
        selectedCourse = course
        if let firstLesson = course.lessons.first {
            startLesson(firstLesson)
        }
    }
    
    func startLesson(_ lesson: Lesson) {
        currentLesson = lesson
        currentExerciseIndex = 0
        lessonProgress = 0.0
        
        if !lesson.exercises.isEmpty {
            currentExercise = lesson.exercises[0]
        }
    }
    
    func submitAnswer(_ answer: Int) {
        guard let exercise = currentExercise else { return }
        
        selectedAnswer = answer
        isCorrect = answer == exercise.correctAnswer
        showingResult = true
        
        // Update progress
        let progressIncrement = 1.0 / Double(currentLesson?.exercises.count ?? 1)
        lessonProgress = min(lessonProgress + progressIncrement, 1.0)
    }
    
    func nextExercise() {
        guard let lesson = currentLesson else { return }
        
        showingResult = false
        selectedAnswer = nil
        
        if currentExerciseIndex < lesson.exercises.count - 1 {
            currentExerciseIndex += 1
            currentExercise = lesson.exercises[currentExerciseIndex]
        } else {
            completeLesson()
        }
    }
    
    func completeLesson() {
        guard let course = selectedCourse else { return }
        
        // Update course progress
        let newProgress = min(course.progress + (1.0 / Double(course.lessons.count)), 1.0)
        dataService.updateCourseProgress(courseId: course.id, progress: newProgress)
        
        // Reset lesson state
        currentLesson = nil
        currentExercise = nil
        currentExerciseIndex = 0
        lessonProgress = 0.0
    }
    
    func getCoursesByDifficulty(_ difficulty: Course.DifficultyLevel) -> [Course] {
        return courses.filter { $0.difficulty == difficulty }
    }
    
    func getCoursesByLanguage(_ language: String) -> [Course] {
        return courses.filter { $0.language == language }
    }
    
    func getAvailableLanguages() -> [String] {
        return Array(Set(courses.map { $0.language })).sorted()
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
    
    func resetProgress() {
        selectedCourse = nil
        currentLesson = nil
        currentExercise = nil
        currentExerciseIndex = 0
        selectedAnswer = nil
        showingResult = false
        lessonProgress = 0.0
    }
}
