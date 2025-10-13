//
//  OnboardingView.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @AppStorage("onboarding_completed") private var onboardingCompleted = false
    
    var body: some View {
        if onboardingCompleted || viewModel.isOnboardingComplete {
            HomeView()
        } else {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color("LightBackground"),
                        Color("DarkBlue").opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress bar
                    VStack(spacing: 16) {
                        HStack {
                            Button("Skip") {
                                viewModel.skipToEnd()
                            }
                            .foregroundColor(Color("DarkBlue"))
                            .font(.system(size: 16, weight: .medium))
                            
                            Spacer()
                            
                            Text("\(viewModel.currentPage + 1) of \(viewModel.onboardingPages.count)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color("DarkBlue").opacity(0.7))
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
                        // Progress bar
                        ProgressView(value: viewModel.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryGreen")))
                            .scaleEffect(y: 2)
                            .padding(.horizontal, 24)
                    }
                    
                    // Content
                    TabView(selection: $viewModel.currentPage) {
                        ForEach(0..<viewModel.onboardingPages.count, id: \.self) { index in
                            OnboardingPageView(page: viewModel.onboardingPages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.5), value: viewModel.currentPage)
                    
                    // Navigation buttons
                    HStack(spacing: 16) {
                        if !viewModel.isFirstPage {
                            Button(action: viewModel.previousPage) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Previous")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("DarkBlue"))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.white.opacity(0.8))
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: viewModel.nextPage) {
                            HStack {
                                Text(viewModel.isLastPage ? "Get Started" : "Next")
                                if !viewModel.isLastPage {
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color("PrimaryGreen"), Color("PrimaryGreen").opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color("PrimaryGreen").opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon with glassmorphism effect
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.25),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(page.primaryColor)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color("DarkBlue"))
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("PrimaryGreen"))
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color("DarkBlue").opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 16)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    OnboardingView()
}
