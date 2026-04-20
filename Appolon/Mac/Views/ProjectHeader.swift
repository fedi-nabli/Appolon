//
//  ProjectHeader.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import SwiftUI

struct ProjectHeader: View {
    @Environment(PanelState.self) private var panelState
    
    let projects: [Project]
    let currentProject: Project?
    
    var body: some View {
        HStack(spacing: 8) {
            projectPicker
            Spacer(minLength: 8)
            actionButtons
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.primary.opacity(0.04))
    }
    
    private var projectPicker: some View {
        Menu {
            if projects.isEmpty {
                Text("No project")
            }
            
            ForEach(projects) { project in
                Button {
                    panelState.selectedProjectID = project.id
                } label: {
                    if project.id == currentProject?.id {
                        Label(project.name, systemImage: "checkmark")
                    } else {
                        Text(project.name)
                    }
                }
            }
            Divider()
            Button {
                // CRUD wired later
            } label: {
                Label("New project", systemImage: "plus")
            }
            .disabled(true)
        } label: {
            HStack(spacing: 6) {
                Text(currentProject?.name ?? "No project")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Image(systemName: "chevron.down")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .fixedSize()
    }
    
    private var actionButtons: some View {
        HStack(spacing: 6) {
            Button {
                // Settings open later
            } label: {
                Image(systemName: "gearshape")
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .help("Settings")
            .disabled(true)
        }
    }
}
