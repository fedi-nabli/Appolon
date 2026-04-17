//
//  TaskList.swift
//  Appolon
//
//  Created by Fedi Nabli on 17/4/2026.
//

import SwiftData
import Foundation

@Model
final class TaskList {
    var id: UUID = UUID()
    var name: String = ""
    var order: Int = 0
    var collapsed: Bool = false
    
    @Relationship(inverse: \Project.lists)
    var project: Project?
    
    @Relationship(deleteRule: .cascade)
    var tasks: [AppolonTask]? = []
    
    init(name: String, order: Int = 0) {
        self.id = UUID()
        self.name = name
        self.order = order
        self.collapsed = false
    }
}

extension TaskList {
    var tasksOrdered: [AppolonTask] {
        (tasks ?? []).sorted { $0.order < $1.order }
    }
}
