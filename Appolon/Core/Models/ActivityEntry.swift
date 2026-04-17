//
//  ActivityEntry.swift
//  Appolon
//
//  Created by Fedi Nabli on 16/4/2026.
//

import Foundation
import SwiftData

@Model
final class ActivityEntry {
    var id: UUID = UUID()
    var timestamp: Date = Date()
    var kindRaw: String = ActivityKind.taskAdded.rawValue
    
    // We copy the titles so logs survive task/list deletion
    var taskTitle: String = ""
    var listName: String = ""
    
    @Relationship(inverse: \Project.activityLog)
    var project: Project?
    
    init(kind: ActivityKind, taskTitle: String, listName: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.timestamp = timestamp
        self.kindRaw = kind.rawValue
        self.taskTitle = taskTitle
        self.listName = listName
    }
}

extension ActivityEntry {
    var kind: ActivityKind {
        get { ActivityKind(rawValue: kindRaw) ?? .stateChanged }
        set { kindRaw = newValue.rawValue }
    }
}
