//
//  SubtaskRow.swift
//  Appolon
//
//  Created by Fedi Nabli on 19/4/2026.
//

import SwiftUI
import SwiftData

struct SubtaskRow: View {
    @Bindable var subtask: Subtask
    @Environment(\.modelContext) private var context
    
    @State private var isHovering: Bool = false
    @State private var isEditing: Bool = false
    @State private var draftTitle: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            checkbox
            titleArea
            Spacer()
            deleteButton.hoverReveal(isHovering)
        }
        .onHover {
            isHovering = $0
        }
    }
    
    private var checkbox: some View {
        Button {
            subtask.done.toggle()
            subtask.task?.lastTouched = Date()
        } label: {
            Image(systemName: subtask.done ? "checkmark.square.fill" : "square")
                .font(.system(size: 12))
                .foregroundStyle(subtask.done ? .green : .secondary)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var titleArea: some View {
        if isEditing {
            TextField("subtask", text: $draftTitle)
                .textFieldStyle(.plain)
                .font(.caption)
                .focused($isFocused)
                .onSubmit {
                    commitTitle()
                }
                .onExitCommand {
                    cancelEditing()
                }
        } else {
            Text(subtask.title)
                .font(.caption)
                .strikethrough(subtask.done, color: .secondary)
                .foregroundStyle(subtask.done ? .secondary : .primary)
                .lineLimit(1)
                .onTapGesture(count: 2) {
                    draftTitle = subtask.title
                    isEditing = true
                    isFocused = true
                }
        }
    }
    
    private var deleteButton: some View {
        Button(role: .destructive) {
            context.delete(subtask)
        } label: {
            Image(systemName: "xmark.circle")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .buttonStyle(.plain)
        .help("Delete subtask")
    }
    
    private func commitTitle() {
        let trimmed = draftTitle.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            subtask.title = trimmed
        }
        isEditing = false
    }
    
    private func cancelEditing() {
        isEditing = false
    }
}
