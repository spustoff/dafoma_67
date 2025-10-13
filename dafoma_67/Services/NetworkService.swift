//
//  NetworkService.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import Foundation
import Combine

class NetworkService: ObservableObject {
    static let shared = NetworkService()
    
    private let session = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    // MARK: - Course Content Updates
    func fetchLatestCourses() -> AnyPublisher<[Course], Error> {
        // Simulate network call - in real app, this would connect to your backend
        return Future<[Course], Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                // Simulate successful response
                promise(.success(Course.sampleCourses))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchBusinessSkills() -> AnyPublisher<[BusinessSkill], Error> {
        return Future<[BusinessSkill], Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.8) {
                promise(.success(BusinessSkill.sampleSkills))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchEntertainmentChallenges() -> AnyPublisher<[EntertainmentChallenge], Error> {
        return Future<[EntertainmentChallenge], Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
                promise(.success(EntertainmentChallenge.sampleChallenges))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - User Progress Sync
    func syncUserProgress(_ progress: UserProgress) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                // Simulate successful sync
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Content Validation
    func validateExerciseAnswer(exerciseId: UUID, answer: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                // In a real app, this would validate against server
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Leaderboard & Social Features
    func fetchLeaderboard() -> AnyPublisher<[LeaderboardEntry], Error> {
        return Future<[LeaderboardEntry], Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                let sampleLeaderboard = [
                    LeaderboardEntry(username: "LanguageMaster", points: 15420, level: 16),
                    LeaderboardEntry(username: "CulturalExplorer", points: 12890, level: 13),
                    LeaderboardEntry(username: "BusinessPro", points: 11250, level: 12),
                    LeaderboardEntry(username: "MovieBuff", points: 9870, level: 10),
                    LeaderboardEntry(username: "You", points: DataService.shared.userProgress.totalPoints, level: DataService.shared.userProgress.level)
                ]
                promise(.success(sampleLeaderboard))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Error Handling
    enum NetworkError: Error, LocalizedError {
        case noConnection
        case serverError
        case invalidData
        case timeout
        
        var errorDescription: String? {
            switch self {
            case .noConnection:
                return "No internet connection available"
            case .serverError:
                return "Server error occurred"
            case .invalidData:
                return "Invalid data received"
            case .timeout:
                return "Request timed out"
            }
        }
    }
}

// MARK: - Supporting Models
struct LeaderboardEntry: Identifiable, Codable {
    let id = UUID()
    let username: String
    let points: Int
    let level: Int
}
