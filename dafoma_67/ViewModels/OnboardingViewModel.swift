//
//  OnboardingViewModel.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var isOnboardingComplete = false
    
    let onboardingPages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to LinguaLearn",
            subtitle: "Your journey to multilingual mastery begins here",
            description: "Learn languages through immersive experiences, business scenarios, and cultural entertainment",
            imageName: "globe.americas.fill",
            primaryColor: Color(red: 0.714, green: 0.875, blue: 0.082) // #B6DF15
        ),
        OnboardingPage(
            title: "Interactive Language Courses",
            subtitle: "Real-world conversations await",
            description: "Master languages through practical scenarios and engaging exercises designed for real-life communication",
            imageName: "bubble.left.and.bubble.right.fill",
            primaryColor: Color(red: 0.047, green: 0.141, blue: 0.314) // #0C2450
        ),
        OnboardingPage(
            title: "Business Skills Integration",
            subtitle: "Professional communication mastery",
            description: "Learn business etiquette and communication styles across different cultures to excel globally",
            imageName: "briefcase.fill",
            primaryColor: Color(red: 0.714, green: 0.875, blue: 0.082) // #B6DF15
        ),
        OnboardingPage(
            title: "Entertainment Challenges",
            subtitle: "Culture through movies and music",
            description: "Discover languages through culturally significant films, music, and entertainment from around the world",
            imageName: "tv.and.hifispeaker.fill",
            primaryColor: Color(red: 0.047, green: 0.141, blue: 0.314) // #0C2450
        ),
        OnboardingPage(
            title: "Personalized Learning",
            subtitle: "Your unique path to fluency",
            description: "AI-driven customization adapts to your learning style, pace, and interests for optimal progress",
            imageName: "brain.head.profile.fill",
            primaryColor: Color(red: 0.714, green: 0.875, blue: 0.082) // #B6DF15
        )
    ]
    
    func nextPage() {
        if currentPage < onboardingPages.count - 1 {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPage += 1
            }
        } else {
            completeOnboarding()
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPage -= 1
            }
        }
    }
    
    func skipToEnd() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentPage = onboardingPages.count - 1
        }
    }
    
    func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isOnboardingComplete = true
        }
        // Save onboarding completion status
        UserDefaults.standard.set(true, forKey: "onboarding_completed")
    }
    
    var isLastPage: Bool {
        currentPage == onboardingPages.count - 1
    }
    
    var isFirstPage: Bool {
        currentPage == 0
    }
    
    var progress: Double {
        Double(currentPage + 1) / Double(onboardingPages.count)
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let primaryColor: Color
}
