//
//  Project.swift
//  Appolon
//
//  Created by Fedi Nabli on 16/4/2026.
//

import Foundation
import SwiftData

@Model
final class Project {
    var id: UUID = UUID()
    var name: String = ""
    var projectDescription: String = ""
    var createdAt: Date = Date()
    var archived: Bool = false
    var order: Int = 0
    
    @Relationship(deleteRule: .cascade)
    var lists: [TaskList]? = []
    
    @Relationship(deleteRule: .cascade)
    var activityLog: [ActivityEntry]? = []
    
    init(name: String, description: String = "", order: Int = 0) {
        self.id = UUID()
        self.name = name
        self.projectDescription = description
        self.createdAt = Date()
        self.archived = false
        self.order = order
    }
}

extension Project {
    var listsOrdered: [TaskList] {
        (lists ?? []).sorted { $0.order < $1.order }
    }
    
    var activitySorted: [ActivityEntry] {
        (activityLog ?? []).sorted { $0.timestamp > $1.timestamp }
    }
}
