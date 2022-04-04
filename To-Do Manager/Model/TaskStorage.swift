//
//  TaskStorage.swift
//  To-Do Manager
//
//  Created by Karpinets Alexander on 09.03.2022.
//

import Foundation

protocol TaskStorageProtocol {
    func loadTasks() -> [TaskProtocol]
    func saveTasks(_ tasks: [TaskProtocol])
}

class TasksStorage: TaskStorageProtocol {
    private var storage = UserDefaults.standard
    var storageKey: String = "tasks"
    private enum TaskKey: String {
        case title
        case type
        case status
    }
    
    func loadTasks() -> [TaskProtocol] {
        var resultTask: [TaskProtocol] = []
        let tasksFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        for task in tasksFromStorage {
            guard let title = task[TaskKey.title.rawValue],
                  let typeRaw = task[TaskKey.type.rawValue],
                  let statusRaw = task[TaskKey.status.rawValue]
            else {
                continue
            }
            let type: TaskPriority = typeRaw == "important" ? .important : .normal
            let status: TaskStatus = statusRaw == "planned" ? .planned : .completed
            resultTask.append(Task(title: title, type: type, status: status))
        }
        return resultTask
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
        var arrayForStorage: [[String:String]] = []
        tasks.forEach { task in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[TaskKey.title.rawValue] = task.title
            newElementForStorage[TaskKey.type.rawValue] = (task.type == .important) ? "important" : "normal"
            newElementForStorage[TaskKey.status.rawValue] = (task.status == .planned) ? "planned" : "completed"
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}
