//
//  CourseModel.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import Foundation

struct Course: Identifiable, Codable {
    let id = UUID()
    let title: String
    let language: String
    let description: String
    let difficulty: DifficultyLevel
    let lessons: [Lesson]
    let progress: Double
    let estimatedTime: String
    let flag: String
    
    enum DifficultyLevel: String, CaseIterable, Codable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
}

struct Lesson: Identifiable, Codable {
    let id = UUID()
    let title: String
    let content: String
    let exercises: [Exercise]
    let isCompleted: Bool
    let duration: Int // in minutes
}

struct Exercise: Identifiable, Codable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let type: ExerciseType
    
    enum ExerciseType: String, CaseIterable, Codable {
        case multipleChoice = "Multiple Choice"
        case fillInBlank = "Fill in the Blank"
        case pronunciation = "Pronunciation"
        case translation = "Translation"
    }
}

// Sample data
extension Course {
    static let sampleCourses: [Course] = [
        Course(
            title: "Spanish Essentials",
            language: "Spanish",
            description: "Learn the fundamentals of Spanish with real-life scenarios",
            difficulty: .beginner,
            lessons: [
                Lesson(
                    title: "Greetings & Introductions",
                    content: "Learn how to greet people and introduce yourself in Spanish",
                    exercises: [
                        Exercise(
                            question: "How do you say 'Hello' in Spanish?",
                            options: ["Hola", "Adiós", "Gracias", "Por favor"],
                            correctAnswer: 0,
                            explanation: "'Hola' is the most common way to say hello in Spanish",
                            type: .multipleChoice
                        )
                    ],
                    isCompleted: false,
                    duration: 15
                )
            ],
            progress: 0.0,
            estimatedTime: "2 weeks",
            flag: "🇪🇸"
        ),
        Course(
            title: "Business French",
            language: "French",
            description: "Professional French for business communication",
            difficulty: .intermediate,
            lessons: [
                Lesson(
                    title: "Business Meetings",
                    content: "Learn professional vocabulary for business meetings",
                    exercises: [
                        Exercise(
                            question: "How do you say 'meeting' in French?",
                            options: ["Réunion", "Bureau", "Travail", "Projet"],
                            correctAnswer: 0,
                            explanation: "'Réunion' means meeting in French",
                            type: .multipleChoice
                        )
                    ],
                    isCompleted: false,
                    duration: 20
                )
            ],
            progress: 0.0,
            estimatedTime: "3 weeks",
            flag: "🇫🇷"
        ),
        Course(
            title: "Japanese Culture & Language",
            language: "Japanese",
            description: "Immerse yourself in Japanese culture while learning the language",
            difficulty: .advanced,
            lessons: [
                Lesson(
                    title: "Honorific Language",
                    content: "Understanding keigo (honorific language) in Japanese",
                    exercises: [
                        Exercise(
                            question: "Which is the polite form of 'to eat'?",
                            options: ["食べる", "召し上がる", "飲む", "見る"],
                            correctAnswer: 1,
                            explanation: "召し上がる (meshiagaru) is the honorific form of 'to eat'",
                            type: .multipleChoice
                        )
                    ],
                    isCompleted: false,
                    duration: 25
                )
            ],
            progress: 0.0,
            estimatedTime: "4 weeks",
            flag: "🇯🇵"
        )
    ]
}
