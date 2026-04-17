//
//  SeedData.swift
//  Appolon
//
//  Created by Fedi Nabli on 17/4/2026.
//

import SwiftData
import Foundation

enum SeedData {
    private static let seededKey = "appolon.didSeedInitialData.v1"
    
    static func seedIfNeeded(in context: ModelContext) {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: seededKey) else { return }
        
        // Check store is empty too
        let descriptor = FetchDescriptor<Project>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else {
            defaults.set(true, forKey: seededKey)
            return
        }
        
        let project = Project(
            name: "Synapse Engine",
            description: "An optimized lightweight, vendor independent ML and DL engine made using C/C++/Rust and Zig.",
            order: 0
        )
        context.insert(project)
        
        // List 1: SMO implementation
        let smoList = TaskList(name: "SMO Implementation", order: 0)
        smoList.project = project
        context.insert(smoList)
        
        let task1 = AppolonTask(title: "Fix KKT inversion bug", priority: .high, state: .done, order: 0)
        task1.list = smoList
        task1.completedAt = Date().addingTimeInterval(-3600)
        context.insert(task1)
        
        let task2 = AppolonTask(title: "Error cache drift fix", priority: .medium, state: .inProgress, order: 1)
        task2.list = smoList
        context.insert(task2)
        
        let subtask1 = Subtask(title: "Add cache invalidation on alpha update", order: 0)
        subtask1.done = true
        subtask1.task = task2
        let subtask2 = Subtask(title: "Check cache drift over 1000 iterations", order: 1)
        subtask2.task = task2
        let subtask3 = Subtask(title: "Test with RBF kernel on Telescope", order: 2)
        subtask3.task = task2
        [subtask1, subtask2, subtask3].forEach { context.insert($0) }
        
        let task3 = AppolonTask(title: "Adam optimizer tuning", priority: .low, order: 2)
        task3.list = smoList
        context.insert(task3)
        
        // List 2: Benchlist
        let benchList = TaskList(name: "Benchmarking", order: 1)
        benchList.project = project
        context.insert(benchList)
        
        let task4 = AppolonTask(title: "Add Fedora Linux parser", priority: .low, state: .inProgress, order: 0)
        task4.list = benchList
        context.insert(task4)
        
        let task5 = AppolonTask(title: "Jetson Orin Nano perf_style handling", priority: .medium, order: 1)
        task5.list = benchList
        context.insert(task5)
        
        // Some activity log entries
        let act1 = ActivityEntry(kind: .taskCompleted,
                                 taskTitle: "Fix KKT inversion bug",
                                 listName: "SMO Implementation",
                                 timestamp: Date().addingTimeInterval(-3600))
        act1.project = project
        let act2 = ActivityEntry(kind: .subtaskCompleted,
                                 taskTitle: "Add cache invalidation on alpha update",
                                 listName: "SMO Implementation",
                                 timestamp: Date().addingTimeInterval(-1800))
        act2.project = project
        [act1, act2].forEach { context.insert($0) }
        
        try? context.save()
        defaults.set(true, forKey: seededKey)
    }
    
    // Dev helper: wipe everything, call from debug menu if you want a reset
    static func wipe(in context: ModelContext) {
        try? context.delete(model: Project.self)
        try? context.delete(model: TaskList.self)
        try? context.delete(model: AppolonTask.self)
        try? context.delete(model: Subtask.self)
        try? context.delete(model: ActivityEntry.self)
        try? context.save()
        UserDefaults.standard.set(false, forKey: seededKey)
    }
}
