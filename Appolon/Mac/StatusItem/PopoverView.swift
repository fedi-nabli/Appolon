//
//  PopooverView.swift
//  Appolon
//
//  Created by Fedi Nabli on 17/4/2026.
//

import SwiftUI
import SwiftData

struct PopoverView: View {
    @Environment(\.modelContext) private var context
    
    @Query(
        filter: #Predicate<Project> { !$0.archived },
        sort: \Project.order
    )
    private var projects: [Project]
    
    @State private var selectedProjectID: UUID?
    
    private var selectedProject: Project? {
        if let id = selectedProjectID,
            let match = projects.first(where: { $0.id == id }) {
                return match
            }
        return projects.first
    }
    
    private var allTasks: [AppolonTask] {
        (selectedProject?.listsOrdered ?? [])
            .flatMap { $0.tasksOrdered }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Divider()
            statsStrip
            Divider()
            workingOnSection
            Divider()
            recentSection
            Spacer(minLength: 0)
            footer
        }
        .frame(width: 320)
        .onAppear() {
            if selectedProjectID == nil {
                selectedProjectID = projects.first?.id
            }
        }
    }
    
    private var header: some View {
        Menu {
            ForEach(projects) { project in
                Button(project.name) {
                    selectedProjectID = project.id
                }
            }
            
            if projects.isEmpty {
                Text("No projects")
            }
        } label: {
            HStack(spacing: 6) {
                Text(selectedProject?.name ?? "No project")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
    
    private var statsStrip: some View {
        let tasks = allTasks
        let done = tasks.filter { $0.state == .done }.count
        let inProgress = tasks.filter { $0.state == .inProgress }.count
        let total = tasks.count
        
        return HStack(spacing: 6) {
            Text("\(done)/\(total) done")
            Text("-").foregroundStyle(.tertiary)
            Text("\(inProgress) in progress")
            Spacer()
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }
    
    private var recentSection: some View {
        let entries = Array((selectedProject?.activitySorted ?? []).prefix(5))
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("RECENT")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.tertiary)
            
            if entries.isEmpty {
                Text("No activity yet")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(entries) { entry in
                    recentRow(entry)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
    
    private var workingOnSection: some View {
        let tasks = allTasks.filter { $0.state == .inProgress }
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("CURRENTLY WORKING ON")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.tertiary)
            
            if tasks.isEmpty {
                Text("No tasks in progress")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(tasks) { task in
                    workinOnRow(task)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
    
    private var footer: some View {
        HStack {
            Spacer()
            Text("Open Panel")
                .font(.callout)
                .foregroundStyle(.secondary)
            Text("Command + Shift + Space")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.secondary.opacity(0.06))
    }
    
    private func workinOnRow(_ task: AppolonTask) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Circle()
                .fill(task.priority.color)
                .frame(width: 6, height: 6)
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.callout)
                    .lineLimit(1)
                let complete = task.subtaskCompletion
                if complete.total > 0 {
                    Text("\(complete.done)/\(complete.total) subtasks")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
    }
    
    private func recentRow(_ entry: ActivityEntry) -> some View {
        HStack(spacing: 8) {
            Image(systemName: entry.kind.iconName)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 14)
            Text(entry.taskTitle)
                .font(.callout)
                .lineLimit(1)
            Spacer()
            Text(relativeTime(entry.timestamp))
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
    
    private func relativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
