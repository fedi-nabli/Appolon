//
//  Subtask.swift
//  Appolon
//
//  Created by Fedi Nabli on 17/4/2026.
//

import SwiftData
import Foundation

@Model
final class Subtask {
    var id: UUID = UUID()
    var title: String = ""
    var done: Bool = false
    var order: Int = 0
    
    @Relationship(inverse: \AppolonTask.subtasks)
    var task: AppolonTask?
    
    init(title: String, order: Int = 0) {
        self.id = UUID()
        self.title = title
        self.done = false
        self.order = order
    }
}
