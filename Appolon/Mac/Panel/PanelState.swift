//
//  PanelState.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import Foundation
import Observation

@Observable
final class PanelState {
    /// Currently selected project, nil = first available
    var selectedProjectID: UUID?
    
    /// Whether the project description is expanded
    var descriptionExpanded: Bool = false
    
    /// Set of Task IDs whose subtask are currently expanded in the panel
    var expandedTaskIDs: Set<UUID> = []
    
    /// Currenty selected task (for keyboard nav), nil = no task selected
    var selectedTaskID: UUID?
    
    func isExpanded(_ taskID: UUID) -> Bool {
        expandedTaskIDs.contains(taskID)
    }
    
    func toggleExpanded(_ taskID: UUID) {
        if expandedTaskIDs.contains(taskID) {
            expandedTaskIDs.remove(taskID)
        } else {
            expandedTaskIDs.insert(taskID)
        }
    }
}
