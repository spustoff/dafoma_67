//
//  SkillModel.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import Foundation

struct BusinessSkill: Identifiable, Codable {
    let id = UUID()
    let title: String
    let category: SkillCategory
    let description: String
    let modules: [SkillModule]
    let progress: Double
    let estimatedTime: String
    let icon: String
    
    enum SkillCategory: String, CaseIterable, Codable {
        case communication = "Communication"
        case negotiation = "Negotiation"
        case presentation = "Presentation"
        case networking = "Networking"
        case leadership = "Leadership"
        case etiquette = "Cultural Etiquette"
    }
}

struct SkillModule: Identifiable, Codable {
    let id = UUID()
    let title: String
    let content: String
    let practiceScenarios: [PracticeScenario]
    let isCompleted: Bool
    let duration: Int
}

struct PracticeScenario: Identifiable, Codable {
    let id = UUID()
    let title: String
    let situation: String
    let culturalContext: String
    let keyPhrases: [String]
    let tips: [String]
    let language: String
}

// Sample data
extension BusinessSkill {
    static let sampleSkills: [BusinessSkill] = [
        BusinessSkill(
            title: "International Business Communication",
            category: .communication,
            description: "Master professional communication across cultures",
            modules: [
                SkillModule(
                    title: "Email Etiquette",
                    content: "Learn proper email communication in different cultures",
                    practiceScenarios: [
                        PracticeScenario(
                            title: "Formal Business Email",
                            situation: "Writing a formal proposal to a Japanese client",
                            culturalContext: "Japanese business culture values formality and respect",
                            keyPhrases: ["いつもお世話になっております", "ご検討のほど", "よろしくお願いいたします"],
                            tips: ["Use honorific language", "Be indirect and humble", "Include proper greetings"],
                            language: "Japanese"
                        )
                    ],
                    isCompleted: false,
                    duration: 30
                )
            ],
            progress: 0.0,
            estimatedTime: "1 week",
            icon: "envelope.fill"
        ),
        BusinessSkill(
            title: "Cross-Cultural Negotiation",
            category: .negotiation,
            description: "Navigate negotiations across different cultural contexts",
            modules: [
                SkillModule(
                    title: "German Business Style",
                    content: "Understanding direct communication in German business culture",
                    practiceScenarios: [
                        PracticeScenario(
                            title: "Contract Negotiation",
                            situation: "Negotiating terms with a German supplier",
                            culturalContext: "Germans prefer direct, fact-based communication",
                            keyPhrases: ["Können wir über die Bedingungen sprechen?", "Das ist nicht akzeptabel", "Wir brauchen eine bessere Lösung"],
                            tips: ["Be direct and honest", "Come prepared with facts", "Respect punctuality"],
                            language: "German"
                        )
                    ],
                    isCompleted: false,
                    duration: 45
                )
            ],
            progress: 0.0,
            estimatedTime: "2 weeks",
            icon: "handshake.fill"
        ),
        BusinessSkill(
            title: "Global Presentation Skills",
            category: .presentation,
            description: "Deliver compelling presentations to international audiences",
            modules: [
                SkillModule(
                    title: "French Presentation Style",
                    content: "Adapt your presentation style for French business culture",
                    practiceScenarios: [
                        PracticeScenario(
                            title: "Product Launch Presentation",
                            situation: "Presenting a new product to French stakeholders",
                            culturalContext: "French audiences appreciate intellectual discourse and detailed analysis",
                            keyPhrases: ["Permettez-moi de vous présenter", "Comme vous pouvez le voir", "En conclusion"],
                            tips: ["Use sophisticated language", "Include detailed analysis", "Engage in intellectual discussion"],
                            language: "French"
                        )
                    ],
                    isCompleted: false,
                    duration: 40
                )
            ],
            progress: 0.0,
            estimatedTime: "1.5 weeks",
            icon: "person.3.fill"
        )
    ]
}
