//
//  TaskListViewController.swift
//  CoreDataDemo
//
//  Created by Alexey Efimov on 10.05.2021.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    private let cellID = "cell"
    private var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func fetchData() {
        CoreDataManager.shared.fetchData { (result) in
            switch result {
            case .success(let tasks):
                self.tasks = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func save(task: String) {
        CoreDataManager.shared.save(task) { task in
            self.tasks.append(task)
            self.tableView.insertRows(
                at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                with: .automatic
            )
        }
    }
    
    @objc private func addNewTask() {
        showAlert()
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Edit task
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Delete Task
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let deletedTask = self.tasks[indexPath.row]
            
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            CoreDataManager.shared.delete(deletedTask)
            CoreDataManager.shared.saveContext()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Alert Controller
extension TaskListViewController {
    private func showAlert(task: Task? = nil, comletion: (() -> Void)? = nil) {
        
        let title = task != nil ? "Update task" : "New task"
        
        let alert = AlertController(
            title: title,
            message: "What do you want to do",
            preferredStyle: .alert
        )
        
        alert.action(task: task) { (taskName) in
            if let task = task, let comletion = comletion {
                CoreDataManager.shared.edit(task, newName: taskName)
                comletion()
            } else {
                self.save(task: taskName)
            }
        }
        present(alert, animated: true)
    }
}

