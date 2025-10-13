//
//  ChallengeModel.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import Foundation

struct EntertainmentChallenge: Identifiable, Codable {
    let id = UUID()
    let title: String
    let type: ChallengeType
    let language: String
    let description: String
    let culturalContext: String
    let questions: [ChallengeQuestion]
    let difficulty: DifficultyLevel
    let points: Int
    let timeLimit: Int // in seconds
    let mediaReference: MediaReference?
    
    enum ChallengeType: String, CaseIterable, Codable {
        case movie = "Movie"
        case music = "Music"
        case literature = "Literature"
        case culture = "Culture"
        case history = "History"
    }
    
    enum DifficultyLevel: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}

struct ChallengeQuestion: Identifiable, Codable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let culturalNote: String?
}

struct MediaReference: Codable {
    let title: String
    let year: Int?
    let creator: String
    let genre: String
    let description: String
}

// Sample data
extension EntertainmentChallenge {
    static let sampleChallenges: [EntertainmentChallenge] = [
        EntertainmentChallenge(
            title: "Studio Ghibli Cinema",
            type: .movie,
            language: "Japanese",
            description: "Test your knowledge of Studio Ghibli films and Japanese culture",
            culturalContext: "Studio Ghibli films reflect Japanese values, folklore, and environmental consciousness",
            questions: [
                ChallengeQuestion(
                    question: "In 'Spirited Away', what does Chihiro's name change to?",
                    options: ["Sen", "Rin", "Yuki", "Hana"],
                    correctAnswer: 0,
                    explanation: "Yubaba changes Chihiro's name to Sen (千) as part of her control over the spirit world workers",
                    culturalNote: "Name changing represents loss of identity, a common theme in Japanese folklore"
                ),
                ChallengeQuestion(
                    question: "What does 'totoro' mean in Japanese?",
                    options: ["Forest spirit", "Big belly", "Friendly giant", "It's a made-up word"],
                    correctAnswer: 3,
                    explanation: "Miyazaki created the word 'totoro' specifically for the character",
                    culturalNote: "Many Japanese words in anime are created for artistic effect"
                )
            ],
            difficulty: .medium,
            points: 150,
            timeLimit: 120,
            mediaReference: MediaReference(
                title: "My Neighbor Totoro",
                year: 1988,
                creator: "Hayao Miyazaki",
                genre: "Animation",
                description: "A beloved Japanese animated film about two sisters who discover forest spirits"
            )
        ),
        EntertainmentChallenge(
            title: "French Chanson Classics",
            type: .music,
            language: "French",
            description: "Explore French music culture through classic chansons",
            culturalContext: "French chanson represents the poetic soul of French culture and language",
            questions: [
                ChallengeQuestion(
                    question: "Who sang 'La Vie en Rose'?",
                    options: ["Brigitte Bardot", "Édith Piaf", "Françoise Hardy", "Sylvie Vartan"],
                    correctAnswer: 1,
                    explanation: "Édith Piaf wrote and performed this iconic song in 1947",
                    culturalNote: "Piaf is considered the voice of France and represents resilience through hardship"
                ),
                ChallengeQuestion(
                    question: "What does 'chanson' literally mean?",
                    options: ["Dance", "Song", "Story", "Love"],
                    correctAnswer: 1,
                    explanation: "'Chanson' simply means 'song' in French",
                    culturalNote: "French chanson is characterized by lyrical sophistication and emotional depth"
                )
            ],
            difficulty: .easy,
            points: 100,
            timeLimit: 90,
            mediaReference: MediaReference(
                title: "La Vie en Rose",
                year: 1947,
                creator: "Édith Piaf",
                genre: "Chanson",
                description: "One of the most famous French songs of all time"
            )
        ),
        EntertainmentChallenge(
            title: "Spanish Cinema Golden Age",
            type: .movie,
            language: "Spanish",
            description: "Discover the masterpieces of Spanish and Latin American cinema",
            culturalContext: "Spanish cinema reflects the rich cultural diversity of Spain and Latin America",
            questions: [
                ChallengeQuestion(
                    question: "Who directed 'El Laberinto del Fauno' (Pan's Labyrinth)?",
                    options: ["Pedro Almodóvar", "Guillermo del Toro", "Luis Buñuel", "Alejandro Amenábar"],
                    correctAnswer: 1,
                    explanation: "Guillermo del Toro directed this acclaimed fantasy film in 2006",
                    culturalNote: "The film blends Spanish Civil War history with dark fantasy elements"
                ),
                ChallengeQuestion(
                    question: "What does 'cine' mean in Spanish?",
                    options: ["Theater", "Cinema", "Art", "Culture"],
                    correctAnswer: 1,
                    explanation: "'Cine' is short for 'cinematógrafo' and means cinema",
                    culturalNote: "Spanish cinema has a rich tradition dating back to the early 1900s"
                )
            ],
            difficulty: .hard,
            points: 200,
            timeLimit: 150,
            mediaReference: MediaReference(
                title: "Pan's Labyrinth",
                year: 2006,
                creator: "Guillermo del Toro",
                genre: "Fantasy Drama",
                description: "A dark fantasy film set against the backdrop of the Spanish Civil War"
            )
        )
    ]
}
