//
//  DataManager.swift
//  ToDoList
//
//  Created by Anastasiia Kuzenkova on 23/04/2018.
//  Copyright © 2018 Anastasiia Kuzenkova. All rights reserved.
//

import UIKit

class Task: NSObject, NSCoding {
    let name: String
    var isCompleted: Bool = false

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "taskName")
        aCoder.encode(isCompleted, forKey: "taskIsCompleted")
    }

    init(name: String) {
        self.name = name
    }

    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "taskName") as! String
        isCompleted = aDecoder.decodeBool(forKey: "taskIsCompleted")
    }
}

class DataManager {
    private(set) var tasks = [Task]()

    init() {
        loadData()
    }

    func archiveTasks(tasks: [Task]) -> Data {
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: tasks as NSArray)
        return archivedObject
    }

    private func loadData() {
        guard let data = UserDefaults.standard.object(forKey: "saved") as? Data else {
            return
        }

        tasks = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Task] ?? []
    }

    func addTask(name: String) {
        tasks.append(Task(name: name))
        save()
    }

    func markAsCompleted(index: Int) {
        tasks[index].isCompleted = true
        save()
    }

    func removeTask(index: Int) {
        tasks.remove(at: index)
        save()
    }

    func progress() -> Float {
        let completed = tasks.filter { $0.isCompleted }.count
        let all = tasks.count

        if all <= 0 {
            return 0
        }

        return Float(completed) / Float(all)
    }

    private func save() {
        let archivedObject = archiveTasks(tasks: tasks)
        let defaults = UserDefaults.standard
        defaults.set(archivedObject, forKey: "saved")
    }
}
