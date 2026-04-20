//
//  ListSection.swift
//  Appolon
//
//  Created by Fedi Nabli on 19/4/2026.
//

import SwiftUI
import SwiftData

struct ListSection: View {
    @Bindable var list: TaskList
    @Environment(\.modelContext) private var context
    
    @State private var isHovering: Bool = false
    @State private var isRenaming: Bool = false
    @State private var draftName: String = ""
    @FocusState private var nameFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            if !list.collapsed {
                tasks
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 6) {
            chevron
            titleArea
            countBadge
            Spacer()
            actions.hoverReveal(isHovering)
        }
        .contentShape(Rectangle())
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .onHover {
            isHovering = $0
        }
    }
    
    private var chevron: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                list.collapsed.toggle()
            }
        } label: {
            Image(systemName: list.collapsed ? "chevron.right" : "chevron.down")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 10)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var titleArea: some View {
        if isRenaming {
            TextField("List name", text: $draftName)
                .textFieldStyle(.plain)
                .font(.subheadline.weight(.semibold))
                .focused($nameFocused)
                .onSubmit {
                    commitRename()
                }
                .onExitCommand {
                    cancelRename()
                }
        } else {
            Text(list.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .onTapGesture(count: 2) {
                    rename()
                }
        }
    }
    
    private var countBadge: some View {
        Text("\(list.tasksOrdered.count)")
            .font(.caption2.monospacedDigit())
            .foregroundStyle(.tertiary)
            .padding(.horizontal, 5)
            .padding(.vertical, 1)
            .background(Capsule().fill(Color.secondary.opacity(0.1)))
    }
    
    private var actions: some View {
        Menu {
            Button {
                rename()
            } label: {
                Label("Rename", systemImage: "pencil")
            }
            Button(role: .destructive) {
                context.delete(list)
            } label: {
                Label("Delete list", systemImage: "trash")
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
    
    private var tasks: some View {
        VStack(alignment: .leading, spacing: 1) {
            if list.tasksOrdered.isEmpty {
                Text("No tasks")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 44)
                    .padding(.vertical, 4)
            } else {
                ForEach(list.tasksOrdered) { task in
                    TaskRow(task: task)
                }
            }
        }
    }
    
    private func rename() {
        draftName = list.name
        isRenaming = true
        nameFocused = true
    }

    private func commitRename() {
        let trimmed = draftName.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            list.name = trimmed
        }
        isRenaming = false
    }
    
    private func cancelRename() {
        isRenaming = false
    }
}
