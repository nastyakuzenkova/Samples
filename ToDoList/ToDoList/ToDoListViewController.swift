//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Anastasiia Kuzenkova on 23/04/2018.
//  Copyright © 2018 Anastasiia Kuzenkova. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!

    private let dataManager = DataManager()

    private let cellId = "CellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "To Do List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ToDoListViewController.addTask))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        updateProgress()
    }

    @objc private func addTask() {
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "New Task"
        }

        let createAction = UIAlertAction(title: "OK", style: .default) { (action) in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }

            self.dataManager.addTask(name: task)
            self.updateProgress()

            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        alert.addAction(createAction)
        present(alert, animated: true, completion: nil)
    }

    private func strikeThroughText(_ text: String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))

        return attributeString
    }

    private func updateProgress() {
        progressView.setProgress(dataManager.progress(), animated: true)
    }
}

extension ToDoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let task = dataManager.tasks[indexPath.row]
        if task.isCompleted {
            cell.textLabel?.attributedText = strikeThroughText(task.name)
        } else {
            cell.textLabel?.text = task.name
        }

        return cell
    }
}

extension ToDoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let task = dataManager.tasks[indexPath.row]
            if task.isCompleted {
                return
            }
            dataManager.markAsCompleted(index: indexPath.row)
            updateProgress()
            cell.textLabel?.attributedText = strikeThroughText(task.name)

            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = cell.transform.scaledBy(x: 1.5, y: 1.5)
            }, completion: { (success) in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.dataManager.removeTask(index: indexPath.row)
            self.updateProgress()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
