//
//  BusinessSkillView.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import SwiftUI

struct BusinessSkillView: View {
    @StateObject private var viewModel = BusinessSkillViewModel()
    @State private var selectedCategory: BusinessSkill.SkillCategory?
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("LightBackground").ignoresSafeArea()
                
                if viewModel.selectedSkill != nil {
                    SkillDetailView(viewModel: viewModel)
                } else {
                    skillListView
                }
            }
            .navigationTitle("Business Skills")
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
                BusinessFilterView(selectedCategory: $selectedCategory)
            }
        }
    }
    
    private var skillListView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Categories overview
                VStack(alignment: .leading, spacing: 16) {
                    Text("Skill Categories")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.getAllCategories(), id: \.self) { category in
                                CategoryCard(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    icon: viewModel.getCategoryIcon(category),
                                    color: viewModel.getCategoryColor(category)
                                ) {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                // Skills grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 16) {
                    ForEach(filteredSkills) { skill in
                        BusinessSkillCard(skill: skill, viewModel: viewModel) {
                            viewModel.selectSkill(skill)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
        .refreshable {
            viewModel.loadBusinessSkills()
        }
    }
    
    private var filteredSkills: [BusinessSkill] {
        if let category = selectedCategory {
            return viewModel.getSkillsByCategory(category)
        }
        return viewModel.businessSkills
    }
}

struct CategoryCard: View {
    let category: BusinessSkill.SkillCategory
    let isSelected: Bool
    let icon: String
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : color)
                
                Text(category.rawValue)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isSelected ? .white : Color("DarkBlue"))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: 100, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? color : Color.white.opacity(0.8))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BusinessSkillCard: View {
    let skill: BusinessSkill
    let viewModel: BusinessSkillViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(viewModel.getCategoryColor(skill.category).opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: skill.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(viewModel.getCategoryColor(skill.category))
                }
                
                // Skill info
                VStack(alignment: .leading, spacing: 8) {
                    Text(skill.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                        .multilineTextAlignment(.leading)
                    
                    Text(skill.description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("DarkBlue").opacity(0.7))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Label(skill.estimatedTime, systemImage: "clock")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("DarkBlue").opacity(0.6))
                        
                        Spacer()
                        
                        Text("\(Int(skill.progress * 100))% Complete")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("PrimaryGreen"))
                    }
                    
                    ProgressView(value: skill.progress)
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
}

struct SkillDetailView: View {
    @ObservedObject var viewModel: BusinessSkillViewModel
    
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
                
                if let skill = viewModel.selectedSkill {
                    VStack(spacing: 4) {
                        Text(skill.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("DarkBlue"))
                            .multilineTextAlignment(.center)
                        
                        Text(skill.category.rawValue)
                            .font(.system(size: 12, weight: .medium))
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
            
            if viewModel.showingScenarioDetail {
                ScenarioDetailView(viewModel: viewModel)
            } else {
                ModuleListView(viewModel: viewModel)
            }
        }
    }
}

struct ModuleListView: View {
    @ObservedObject var viewModel: BusinessSkillViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let skill = viewModel.selectedSkill {
                    // Skill progress
                    VStack(spacing: 12) {
                        HStack {
                            Text("Skill Progress")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("DarkBlue"))
                            
                            Spacer()
                            
                            Text("\(Int(skill.progress * 100))%")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color("PrimaryGreen"))
                        }
                        
                        ProgressView(value: skill.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color("PrimaryGreen")))
                            .scaleEffect(y: 2)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Modules
                    LazyVStack(spacing: 12) {
                        ForEach(skill.modules) { module in
                            ModuleCard(module: module, viewModel: viewModel) {
                                viewModel.startModule(module)
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

struct ModuleCard: View {
    let module: SkillModule
    let viewModel: BusinessSkillViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(module.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("DarkBlue"))
                            .multilineTextAlignment(.leading)
                        
                        Text("\(module.practiceScenarios.count) scenarios • \(viewModel.formatDuration(module.duration))")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("DarkBlue").opacity(0.7))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(module.isCompleted ? Color("PrimaryGreen") : Color("DarkBlue").opacity(0.1))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: module.isCompleted ? "checkmark" : "play.fill")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(module.isCompleted ? .white : Color("DarkBlue"))
                    }
                }
                
                Text(module.content)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("DarkBlue").opacity(0.8))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Practice scenarios preview
                if !module.practiceScenarios.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Practice Scenarios:")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("DarkBlue"))
                        
                        ForEach(module.practiceScenarios.prefix(2)) { scenario in
                            HStack {
                                Text(viewModel.getLanguageFlag(scenario.language))
                                    .font(.system(size: 14))
                                
                                Text(scenario.title)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color("DarkBlue").opacity(0.7))
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                        }
                        
                        if module.practiceScenarios.count > 2 {
                            Text("+ \(module.practiceScenarios.count - 2) more scenarios")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color("PrimaryGreen"))
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("LightBackground").opacity(0.5))
                    )
                }
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

struct ScenarioDetailView: View {
    @ObservedObject var viewModel: BusinessSkillViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let scenario = viewModel.currentScenario {
                    // Header
                    VStack(spacing: 12) {
                        HStack {
                            Text(viewModel.getLanguageFlag(scenario.language))
                                .font(.system(size: 32))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(scenario.title)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color("DarkBlue"))
                                
                                Text(scenario.language)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color("DarkBlue").opacity(0.7))
                            }
                            
                            Spacer()
                        }
                        
                        Text(scenario.situation)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color("DarkBlue"))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Cultural context
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Cultural Context")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("DarkBlue"))
                        
                        Text(scenario.culturalContext)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color("DarkBlue").opacity(0.8))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("PrimaryGreen").opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color("PrimaryGreen").opacity(0.3), lineWidth: 1)
                            )
                    )
                    
                    // Key phrases
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Key Phrases")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("DarkBlue"))
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 8) {
                            ForEach(scenario.keyPhrases, id: \.self) { phrase in
                                HStack {
                                    Text(phrase)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color("DarkBlue"))
                                    
                                    Spacer()
                                    
                                    Button(action: {}) {
                                        Image(systemName: "speaker.wave.2")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color("PrimaryGreen"))
                                    }
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.8))
                                )
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("DarkBlue").opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color("DarkBlue").opacity(0.1), lineWidth: 1)
                            )
                    )
                    
                    // Tips
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Professional Tips")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("DarkBlue"))
                        
                        ForEach(scenario.tips, id: \.self) { tip in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.orange)
                                    .padding(.top, 2)
                                
                                Text(tip)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color("DarkBlue").opacity(0.8))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
            }
            .padding(20)
        }
        .background(Color("LightBackground").ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { viewModel.showingScenarioDetail = false }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("DarkBlue"))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Complete") {
                    if let scenario = viewModel.currentScenario {
                        viewModel.completeScenario(scenario)
                        viewModel.showingScenarioDetail = false
                    }
                }
                .foregroundColor(Color("PrimaryGreen"))
            }
        }
    }
}

struct BusinessFilterView: View {
    @Binding var selectedCategory: BusinessSkill.SkillCategory?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Skill Category")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("DarkBlue"))
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(BusinessSkill.SkillCategory.allCases, id: \.self) { category in
                            FilterChip(
                                title: category.rawValue,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = selectedCategory == category ? nil : category
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button("Clear Filter") {
                    selectedCategory = nil
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("DarkBlue"))
            }
            .padding(20)
            .navigationTitle("Filter Skills")
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

#Preview {
    BusinessSkillView()
}
