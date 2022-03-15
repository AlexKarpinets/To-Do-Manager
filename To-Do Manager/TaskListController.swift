//
//  TaskListController.swift
//  To-Do Manager
//
//  Created by Karpinets Alexander on 09.03.2022.
//

import UIKit

class TaskListController: UITableViewController {
    
    var taskStorage: TaskStorageProtocol = TasksStorage()
    var tasks: [TaskPriority:[TaskProtocol]] = [:]
    var sectionsTypesPosition: [TaskPriority] = [.important, .normal]
    var taskStatusPosition: [TaskStatus] = [.planned, .completed]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskType = sectionsTypesPosition[section]
        guard let currentTaskType = tasks[taskType] else { return 0}
        return currentTaskType.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getConfiguredTaskCell_stack(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let taskType = sectionsTypesPosition[section]
        if taskType == .important {
            title = "Важные"
        } else if taskType == .normal {
            title = "Текущие"
        }
        return title
    }
    
    private func loadTasks() {
        sectionsTypesPosition.forEach { taskType in
            tasks[taskType] = []
        }
        taskStorage.loadTasks().forEach { task in
            tasks[task.type]?.append(task)
        }
        for (tasksGroupPriority, taskGroup) in tasks {
            tasks[tasksGroupPriority] = taskGroup.sorted { task1, task2 in
                let task1position = taskStatusPosition.firstIndex(of: task1.status) ?? 0
                let task2position = taskStatusPosition.firstIndex(of: task2.status) ?? 0
                return task1position < task2position
            }
        }
    }
    
//    private func getConfiguredTaskCell_constraints(for indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
//        let taskType = sectionsTypesPosition[indexPath.section]
//        guard let currentTask = tasks[taskType]?[indexPath.row] else { return cell }
//
//        let symbolLabel = cell.viewWithTag(1) as? UILabel
//        let textLabel = cell.viewWithTag(2) as? UILabel
//        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
//        textLabel?.text = currentTask.title
//
//        if currentTask.status == .planned {
//            textLabel?.textColor = .black
//            symbolLabel?.textColor = .black
//        } else {
//            textLabel?.textColor = .lightGray
//            symbolLabel?.textColor = .lightGray
//        }
//        return cell
//    }
    
    private func getConfiguredTaskCell_stack(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskCell
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else { return cell }
        
        cell.title.text = currentTask.title
        cell.symbol.text = getSymbolForTask(with: currentTask.status)
        
        if currentTask.status == .planned {
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        } else {
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
        }
        return cell
    }
    
    
    private func getSymbolForTask(with status: TaskStatus) -> String {
        var resultSymbol: String
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .completed {
            resultSymbol = "\u{25C9}"
        } else {
            resultSymbol = ""
        }
        return resultSymbol
    }
}

