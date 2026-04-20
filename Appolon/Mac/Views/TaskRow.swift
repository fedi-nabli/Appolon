//
//  TaskRow.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import SwiftUI
import SwiftData

struct TaskRow: View {
    @Environment(\.modelContext) private var context
    @Environment(PanelState.self) private var panelState
    
    @Bindable var task: AppolonTask
    
    @State private var isHovering: Bool = false
    @State private var isEditing: Bool = false
    @State private var draftTitle: String = ""
    @FocusState private var titleFocused: Bool
    
    private var isExpanded: Bool {
        panelState.isExpanded(task.id)
    }
    
    private var isSelected: Bool {
        panelState.selectedTaskID == task.id
    }
    
    private var hasSubtasks: Bool {
        !(task.subtasks ?? []).isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            mainRow
            if isExpanded && hasSubtasks {
                subtasksList
            }
        }
    }
    
    private var mainRow: some View {
        HStack(spacing: 8) {
            priorityButton
            stateButton
            titleArea
            Spacer(minLength: 8)
            subtaskCountBadge
            rowActions
            expandChevron
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isSelected ? Color.accentColor.opacity(0.15) : .clear)
                .padding(.horizontal, 10)
        )
        .contentShape(Rectangle())
        .onHover {
            isHovering = $0
        }
        .onTapGesture {
            panelState.selectedTaskID = task.id
        }
    }
    
    private var priorityButton: some View {
        Button {
            cyclePriority()
        } label: {
            PriorityDot(priority: task.priority)
        }
        .buttonStyle(.plain)
        .contextMenu {
            ForEach(Priority.allCases) { priority in
                Button {
                    task.priority = priority
                } label: {
                    if priority == task.priority {
                        Label(priority.shortLabel, systemImage: "checkmark")
                    } else {
                        Text(priority.shortLabel)
                    }
                }
            }
        }
        .help("Priority: \(task.priority.shortLabel)")
    }
    
    private var stateButton: some View {
        Button {
            cycleState()
        } label: {
            StateIcon(state: task.state)
        }
        .buttonStyle(.plain)
        .help("State: \(task.state.rawValue)")
    }
    
    @ViewBuilder
    private var titleArea: some View {
        if isEditing {
            TextField("Task title", text: $draftTitle)
                .textFieldStyle(.plain)
                .font(.callout)
                .focused($titleFocused)
                .onSubmit {
                    commitEdit()
                }
                .onExitCommand {
                    cancelEdit()
                }
        } else {
            Text(task.title)
                .font(.callout)
                .strikethrough(task.state == .done, color: .secondary)
                .foregroundStyle(task.state == .done ? .secondary : .primary)
                .lineLimit(1)
                .onTapGesture(count: 2) {
                    beginEdit()
                }
        }
    }
    
    @ViewBuilder
    private var subtaskCountBadge: some View {
        let completion = task.subtaskCompletion
        if completion.total > 0 {
            Text("\(completion.done)/\(completion.total)")
                .font(.caption2.monospacedDigit())
                .foregroundStyle(.tertiary)
                .padding(.horizontal, 5)
                .padding(.vertical, 1)
                .background(Capsule().fill(Color.secondary.opacity(0.12)))
        }
    }
    
    private var rowActions: some View {
        HStack(spacing: 4) {
            Button {
                // Toggle subtask list expansion and optionally
                // add first subtask in next milestone, for now just expand
                if !isExpanded {
                    panelState.toggleExpanded(task.id)
                }
            } label: {
                Image(systemName: "plus.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Add subtask")
            
            Menu {
                Button(role: .destructive) {
                    deleteTask()
                } label: {
                    Label("Delete task", systemImage: "trash")
                }
                Divider()
                Button {
                    beginEdit()
                } label: {
                    Label("Rename", systemImage: "pencil")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 12, height: 12)
                    .contentShape(Rectangle())
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .fixedSize()
        }
        .hoverReveal(isHovering)
    }
    
    @ViewBuilder
    private var expandChevron: some View {
        if hasSubtasks {
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    panelState.toggleExpanded(task.id)
                }
            } label: {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 12)
            }
            .buttonStyle(.plain)
        } else {
            Color.clear.frame(width: 12)
        }
    }
    
    private var subtasksList: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(task.subtasksOrdered) { subtask in
                SubtaskRow(subtask: subtask)
            }
        }
        .padding(.leading, 44)
        .padding(.trailing, 16)
        .padding(.top, 2)
        .padding(.bottom, 4)
    }
    
    private func cyclePriority() {
        let all = Priority.allCases
        let idx = all.firstIndex(of: task.priority) ?? 0
        let nextIdx = all[(idx + 1) % all.count]
        task.priority = nextIdx
    }
    
    private func cycleState() {
        let newState = task.state.next
        task.state = newState
        
        // When a task is done, all subtasks are marked as done
        if newState == .done {
            for subtask in task.subtasksOrdered where !subtask.done {
                subtask.done = true
            }
        }

        // When we loop back and a task is marked as todo, we mark subtasks as undone
        if newState == .todo {
            for subtask in task.subtasksOrdered where subtask.done {
                subtask.done = false
            }
        }
    }
    
    private func deleteTask() {
        context.delete(task)
    }
    
    private func beginEdit() {
        draftTitle = task.title
        isEditing = true
        titleFocused = true
    }
    
    private func commitEdit() {
        let trimmed = draftTitle.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            task.title = trimmed
            task.lastTouched = Date()
        }
        isEditing = false
    }
    
    private func cancelEdit() {
        isEditing = false
    }
}
