//
//  AppolonApp.swift
//  Appolon
//
//  Created by Fedi Nabli on 16/4/2026.
//

import SwiftUI
import SwiftData

@main
struct AppolonApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
        .modelContainer(AppolonModelContainer.shared)
    }
}

private struct SeedCheckView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Project.order) private var projects: [Project]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Appolon seed check")
                .font(.title2).bold()
            
            if projects.isEmpty {
                Text("No projects yet")
            } else {
                ForEach(projects) { project in
                    VStack(alignment: .leading) {
                        Text(project.name).bold()
                        ForEach(project.listsOrdered) { list in
                            Text("  ¬ \(list.name) - \(list.tasksOrdered.count) tasks")
                                .font(.system(.body, design: .monospaced))
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            SeedData.seedIfNeeded(in: context)
        }
    }
}
