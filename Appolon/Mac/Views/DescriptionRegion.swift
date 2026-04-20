//
//  DescriptionRegion.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import SwiftUI

struct DescriptionRegion: View {
    @Bindable var project: Project
    @Environment(PanelState.self) private var panelState
    
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool
    
    private var isExpanded: Bool {
        panelState.descriptionExpanded
    }
    
    private var firstLine: String {
        project.projectDescription
            .split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
            .first
            .map(String.init) ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            if isExpanded {
                content
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private var header: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                panelState.descriptionExpanded.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 10)
                Text("Description")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                if !isExpanded && !firstLine.isEmpty {
                    Text("-")
                        .foregroundStyle(.tertiary)
                    Text(firstLine)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
                Spacer()
                if isExpanded && !isEditing {
                    Button {
                        isEditing = true
                        isFocused = true
                    } label: {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var content: some View {
        if isEditing {
            TextEditor(text: $project.projectDescription)
                .font(.callout)
                .frame(minHeight: 80, maxHeight: 200)
                .scrollContentBackground(.hidden)
                .background(Color.primary.opacity(0.04))
                .cornerRadius(6)
                .padding(.top, 6)
                .focused($isFocused)
                .onSubmit {
                    isEditing = false
                }
                .onExitCommand {
                    isEditing = false
                }
                .overlay(alignment: .bottomLeading) {
                    Text("Cmd + Enter to save")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .padding(4)
                }
                .onKeyPress(.return, phases: .down) { press in
                    if press.modifiers.contains(.command) {
                        isEditing = false
                        return .handled
                    }
                    return .ignored
                }
        } else {
            Text(project.projectDescription.isEmpty
                 ? "No description"
                 : project.projectDescription)
                .font(.callout)
                .foregroundStyle(project.projectDescription.isEmpty ? .tertiary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)
                .onTapGesture(count: 2) {
                    isEditing = true
                    isFocused = true
                }
            
        }
    }
}
