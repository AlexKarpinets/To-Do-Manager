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
    func loadTasks() -> [TaskProtocol] {
        let testTask: [TaskProtocol] = [Task(title: "Купить хлеб", type: .normal, status: .planned),
                                        Task(title: "Помыть кота", type: .important, status: .planned),
                                        Task(title: "Отдать долг Васе, Игорю, Роме, Ване, Пети, Саше, Руслану", type: .important, status: .completed),
                                        Task(title: "Купить пылесос", type: .normal, status: .completed),
                                        Task(title: "Подарить цветы маме", type: .important, status: .planned),
                                        Task(title: "Позвонить родителям", type: .important, status: .planned)]
        return testTask
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
    }
}
