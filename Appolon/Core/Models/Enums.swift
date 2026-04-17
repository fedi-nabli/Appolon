//
//  Enums.swift
//  Appolon
//
//  Created by Fedi Nabli on 16/4/2026.
//

enum TaskState: String, Codable, CaseIterable {
    case todo
    case inProgress
    case done
    
    var next: TaskState {
        switch self {
        case .todo: .inProgress
        case .inProgress: .done
        case .done: .todo
        }
    }
    
    var iconName: String {
        switch self {
        case .todo: "circle"
        case .inProgress: "circle.lefthalf.filled"
        case .done: "largecircle.fill.circle"
        }
    }
}

enum ActivityKind: String, Codable {
    case taskAdded
    case taskCompleted
    case taskReopened
    case stateChanged
    case subtaskAdded
    case subtaskCompleted
    
    var iconName: String {
        switch self {
        case .taskAdded, .subtaskAdded: "plus"
        case .taskCompleted, .subtaskCompleted: "checkmark"
        case .taskReopened: "arrow.uturn.backward"
        case .stateChanged: "arrow.triangle.2.circlepath"
        }
    }
}
