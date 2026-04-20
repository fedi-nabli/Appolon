//
//  StateStrip.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import SwiftUI

struct StatsStrip: View {
    let project: Project
    
    private var allTasks: [AppolonTask] {
        project.listsOrdered.flatMap { $0.tasksOrdered }
    }
    
    private var done: Int {
        allTasks.filter { $0.state == .done }.count
    }
    
    private var inProgress: Int {
        allTasks.filter { $0.state == .inProgress }.count
    }
    
    private var total: Int {
        allTasks.count
    }
    
    private var lastTouchedText: String? {
        guard let latest = allTasks.map(\.lastTouched).max() else { return nil }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: latest, relativeTo: Date())
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(done)/\(total) done")
            separator
            Text("\(inProgress) in progress")
            if let lastTouchedText {
                separator
                Text("last \(lastTouchedText)")
            }
            Spacer()
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
    }
    
    private var separator: some View {
        Text("-").foregroundStyle(.tertiary)
    }
}
