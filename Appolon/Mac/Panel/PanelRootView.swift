//
//  PanelRootView.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import SwiftUI
import SwiftData

struct PanelRootView: View {
    @Query(sort: \Project.order) private var projects: [Project]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Appolon")
                    .font(.title2)
                    .bold()
                Spacer()
                Text("placeholder")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            if projects.isEmpty {
                Text("No projects yet")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(projects) { project in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.name)
                            .font(.headline)
                        ForEach(project.listsOrdered) { list in
                            Text("  \(list.name) - \(list.tasksOrdered.count) tasks")
                                .font(.system(.callout, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            
            Spacer()
            
            Text("Esc to close - Cmd + Shift + Space to toggle")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
