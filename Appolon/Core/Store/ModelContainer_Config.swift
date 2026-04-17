//
//  ModelContainer_Config.swift
//  Appolon
//
//  Created by Fedi Nabli on 17/4/2026.
//

import SwiftData

enum AppolonModelContainer {
    static let shared: ModelContainer = {
        let schema = Schema([
            Project.self,
            TaskList.self,
            AppolonTask.self,
            Subtask.self,
            ActivityEntry.self,
        ])
        
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .none,
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}
