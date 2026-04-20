//
//  PanelRootView.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import SwiftUI
import SwiftData

struct PanelRootView: View {
    @Environment(\.modelContext) private var context
    
    @Query(
        filter: #Predicate<Project> { !$0.archived },
        sort: \Project.order
    )
    private var projects: [Project]
    
    @State private var panelState = PanelState()
    
    private var currentProject: Project? {
        if let id = panelState.selectedProjectID,
           let match = projects.first(where: { $0.id == id }) {
            return match
        }
        return projects.first
    }
    
    private var selectedTask: AppolonTask? {
        guard let id = panelState.selectedTaskID,
              let project = currentProject else { return nil }
        for list in project.listsOrdered {
            if let match = list.tasksOrdered.first(where: { $0.id == id }) {
                return match
            }
        }
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let project = currentProject {
                ProjectHeader(projects: projects, currentProject: project)
                Divider()
                DescriptionRegion(project: project)
                Divider()
                StatsStrip(project: project)
                Divider()
                listsScrollView(for: project)
            } else {
                emptyState
            }
        }
        .environment(panelState)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            if panelState.selectedProjectID == nil {
                panelState.selectedProjectID = projects.first?.id
            }
            SeedData.seedIfNeeded(in: context)
        }
        // Keyboard shortcut for the selected task, onKeyPress fires when
        // the panel has key focus. If no task is selected, the handlers are
        // no ops but return .handled so Space doesn't scroll
        .onKeyPress(.space, phases: .down) { _ in
            guard let task = selectedTask else { return .ignored }
            task.state = task.state.next
            if task.state == .done {
                for subtask in task.subtasksOrdered where !subtask.done {
                    subtask.done = true
                }
            }
            return .handled
        }
        .onKeyPress(characters: .init(charactersIn: "12345"), phases: .down) { press in
            guard let task = selectedTask,
                  let char = press.characters.first,
                  let digit = Int(String(char)),
                  let priority = Priority(rawValue: digit - 1) else {
                return .ignored
            }
            task.priority = priority
            return .handled
        }
    }
    
    private func listsScrollView(for project: Project) -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(project.listsOrdered) { list in
                    ListSection(list: list)
                    Divider()
                        .padding(.horizontal, 14)
                }
            }
            .padding(.top, 4)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(.tertiary)
            Text("No projects yet")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Create your first project to get started")
                .font(.callout)
                .foregroundStyle(.tertiary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
