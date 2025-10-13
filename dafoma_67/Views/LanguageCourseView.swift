//
//  LanguageCourseView.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import SwiftUI

struct LanguageCourseView: View {
    @StateObject private var viewModel = LanguageCourseViewModel()
    @State private var selectedDifficulty: Course.DifficultyLevel?
    @State private var selectedLanguage: String?
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("LightBackground").ignoresSafeArea()
                
                if viewModel.selectedCourse != nil {
                    CourseDetailView(viewModel: viewModel)
                } else {
                    courseListView
                }
            }
            .navigationTitle("Language Courses")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(Color("PrimaryGreen"))
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(
                    selectedDifficulty: $selectedDifficulty,
                    selectedLanguage: $selectedLanguage,
                    availableLanguages: viewModel.getAvailableLanguages()
                )
            }
        }
    }
    
    private var courseListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Header stats
                HStack(spacing: 16) {
                    StatBadge(
                        title: "Available Courses",
                        value: "\(filteredCourses.count)",
                        icon: "book.fill",
                        color: Color("PrimaryGreen")
                    )
                    
                    StatBadge(
                        title: "Languages",
                        value: "\(viewModel.getAvailableLanguages().count)",
                        icon: "globe.americas.fill",
                        color: Color("DarkBlue")
                    )
                }
                .padding(.horizontal, 20)
                
                // Courses grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 16) {
                    ForEach(filteredCourses) { course in
                        CourseRowCard(course: course) {
                            viewModel.selectCourse(course)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
        .refreshable {
            viewModel.loadCourses()
        }
    }
    
    private var filteredCourses: [Course] {
        var courses = viewModel.courses
        
        if let difficulty = selectedDifficulty {
            courses = courses.filter { $0.difficulty == difficulty }
        }
        
        if let language = selectedLanguage {
            courses = courses.filter { $0.language == language }
        }
        
        return courses
    }
}

struct CourseRowCard: View {
    let course: Course
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Flag and difficulty
                VStack(spacing: 8) {
                    Text(course.flag)
                        .font(.system(size: 32))
                    
                    Text(course.difficulty.rawValue)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(getDifficultyColor(course.difficulty))
                        )
                }
                
                // Course info
                VStack(alignment: .leading, spacing: 8) {
                    Text(course.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                        .multilineTextAlignment(.leading)
                    
                    Text(course.description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("DarkBlue").opacity(0.7))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Label(course.estimatedTime, systemImage: "clock")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("DarkBlue").opacity(0.6))
                        
                        Spacer()
                        
                        Text("\(Int(course.progress * 100))% Complete")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("PrimaryGreen"))
                    }
                    
                    ProgressView(value: course.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryGreen")))
                        .scaleEffect(y: 1.5)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("DarkBlue").opacity(0.5))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getDifficultyColor(_ difficulty: Course.DifficultyLevel) -> Color {
        switch difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        }
    }
}

struct CourseDetailView: View {
    @ObservedObject var viewModel: LanguageCourseViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { viewModel.resetProgress() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color("DarkBlue"))
                }
                
                Spacer()
                
                if let course = viewModel.selectedCourse {
                    VStack(spacing: 4) {
                        Text(course.title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("DarkBlue"))
                        
                        Text(course.language)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color("DarkBlue").opacity(0.7))
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color("PrimaryGreen"))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white.opacity(0.9))
            
            if viewModel.currentExercise != nil {
                ExerciseView(viewModel: viewModel)
            } else {
                LessonListView(viewModel: viewModel)
            }
        }
    }
}

struct LessonListView: View {
    @ObservedObject var viewModel: LanguageCourseViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let course = viewModel.selectedCourse {
                    // Course progress
                    VStack(spacing: 12) {
                        HStack {
                            Text("Course Progress")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("DarkBlue"))
                            
                            Spacer()
                            
                            Text("\(Int(course.progress * 100))%")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color("PrimaryGreen"))
                        }
                        
                        ProgressView(value: course.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryGreen")))
                            .scaleEffect(y: 2)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Lessons
                    LazyVStack(spacing: 12) {
                        ForEach(course.lessons) { lesson in
                            LessonCard(lesson: lesson) {
                                viewModel.startLesson(lesson)
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Color("LightBackground").ignoresSafeArea())
    }
}

struct LessonCard: View {
    let lesson: Lesson
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Lesson icon
                ZStack {
                    Circle()
                        .fill(lesson.isCompleted ? Color("PrimaryGreen") : Color("DarkBlue").opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: lesson.isCompleted ? "checkmark" : "play.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(lesson.isCompleted ? .white : Color("DarkBlue"))
                }
                
                // Lesson info
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                        .multilineTextAlignment(.leading)
                    
                    Text("\(lesson.exercises.count) exercises • \(lesson.duration) min")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("DarkBlue").opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("DarkBlue").opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ExerciseView: View {
    @ObservedObject var viewModel: LanguageCourseViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            if let lesson = viewModel.currentLesson {
                VStack(spacing: 8) {
                    HStack {
                        Text("Question \(viewModel.currentExerciseIndex + 1) of \(lesson.exercises.count)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color("DarkBlue").opacity(0.7))
                        
                        Spacer()
                        
                        Text("\(Int(viewModel.lessonProgress * 100))%")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("PrimaryGreen"))
                    }
                    
                    ProgressView(value: viewModel.lessonProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryGreen")))
                        .scaleEffect(y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.9))
            }
            
            // Exercise content
            ScrollView {
                VStack(spacing: 24) {
                    if let exercise = viewModel.currentExercise {
                        VStack(spacing: 20) {
                            // Question
                            Text(exercise.question)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color("DarkBlue"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            
                            // Options
                            VStack(spacing: 12) {
                                ForEach(0..<exercise.options.count, id: \.self) { index in
                                    OptionButton(
                                        text: exercise.options[index],
                                        isSelected: viewModel.selectedAnswer == index,
                                        isCorrect: viewModel.showingResult && index == exercise.correctAnswer,
                                        isWrong: viewModel.showingResult && viewModel.selectedAnswer == index && index != exercise.correctAnswer,
                                        showingResult: viewModel.showingResult
                                    ) {
                                        if !viewModel.showingResult {
                                            viewModel.submitAnswer(index)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Result explanation
                            if viewModel.showingResult {
                                VStack(spacing: 12) {
                                    HStack {
                                        Image(systemName: viewModel.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(viewModel.isCorrect ? .green : .red)
                                        
                                        Text(viewModel.isCorrect ? "Correct!" : "Incorrect")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(viewModel.isCorrect ? .green : .red)
                                        
                                        Spacer()
                                    }
                                    
                                    Text(exercise.explanation)
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(Color("DarkBlue").opacity(0.8))
                                        .multilineTextAlignment(.leading)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.8))
                                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .padding(.vertical, 24)
            }
            .background(Color("LightBackground").ignoresSafeArea())
            
            // Next button
            if viewModel.showingResult {
                Button(action: viewModel.nextExercise) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("PrimaryGreen"))
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
                .background(Color.white.opacity(0.9))
            }
        }
    }
}

struct OptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let showingResult: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if showingResult {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if isWrong {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        if showingResult {
            if isCorrect {
                return .green.opacity(0.1)
            } else if isWrong {
                return .red.opacity(0.1)
            }
        }
        return isSelected ? Color("PrimaryGreen").opacity(0.1) : Color.white.opacity(0.8)
    }
    
    private var borderColor: Color {
        if showingResult {
            if isCorrect {
                return .green
            } else if isWrong {
                return .red
            }
        }
        return isSelected ? Color("PrimaryGreen") : Color.clear
    }
    
    private var textColor: Color {
        if showingResult {
            if isCorrect {
                return .green
            } else if isWrong {
                return .red
            }
        }
        return Color("DarkBlue")
    }
}

struct FilterView: View {
    @Binding var selectedDifficulty: Course.DifficultyLevel?
    @Binding var selectedLanguage: String?
    let availableLanguages: [String]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Difficulty Level")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    HStack(spacing: 12) {
                        ForEach(Course.DifficultyLevel.allCases, id: \.self) { difficulty in
                            FilterChip(
                                title: difficulty.rawValue,
                                isSelected: selectedDifficulty == difficulty
                            ) {
                                selectedDifficulty = selectedDifficulty == difficulty ? nil : difficulty
                            }
                        }
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Language")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(availableLanguages, id: \.self) { language in
                            FilterChip(
                                title: language,
                                isSelected: selectedLanguage == language
                            ) {
                                selectedLanguage = selectedLanguage == language ? nil : language
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button("Clear All Filters") {
                    selectedDifficulty = nil
                    selectedLanguage = nil
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("DarkBlue"))
            }
            .padding(20)
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color("PrimaryGreen"))
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : Color("DarkBlue"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color("PrimaryGreen") : Color.white.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("PrimaryGreen"), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatBadge: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color("DarkBlue"))
                
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color("DarkBlue").opacity(0.7))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
        )
    }
}

#Preview {
    LanguageCourseView()
}
