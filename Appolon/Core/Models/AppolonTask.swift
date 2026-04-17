//
//  AppolonTask.swift
//  Appolon
//
//  Created by Fedi Nabli on 17/4/2026.
//

import SwiftData
import Foundation

@Model
final class AppolonTask {
    var id: UUID = UUID()
    var title: String = ""
    var notes: String = ""
    var stateRaw: String = TaskState.todo.rawValue
    var priorityRaw: Int = Priority.lowest.rawValue
    var order: Int = 0
    var createdAt: Date = Date()
    var completedAt: Date?
    var lastTouched: Date = Date()
    
    @Relationship(inverse: \TaskList.tasks)
    var list: TaskList?
    
    @Relationship(deleteRule: .cascade)
    var subtasks: [Subtask]? = []
    
    init(title: String,
         priority: Priority = .lowest,
         state: TaskState = .todo,
         order: Int = 0) {
        self.id = UUID()
        self.title = title
        self.notes = ""
        self.stateRaw = state.rawValue
        self.priorityRaw = priority.rawValue
        self.order = order
        self.createdAt = Date()
        self.lastTouched = Date()
    }
}

extension AppolonTask {
    var state: TaskState {
        get { TaskState(rawValue: stateRaw) ?? .todo }
        set {
            stateRaw = newValue.rawValue
            lastTouched = Date()
            if newValue == .done {
                completedAt = Date()
            } else if completedAt != nil {
                completedAt = nil
            }
        }
    }
    
    var priority: Priority {
        get { Priority(rawValue: priorityRaw) ?? .lowest }
        set {
            priorityRaw = newValue.rawValue
            lastTouched = Date()
        }
    }
    
    var subtasksOrdered: [Subtask] {
        (subtasks ?? []).sorted { $0.order < $1.order }
    }
    
    var subtaskCompletion: (done: Int, total: Int) {
        let subs = subtasks ?? []
        return (subs.filter(\.done).count, subs.count)
    }
}
