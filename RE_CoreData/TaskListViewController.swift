//
//  TaskListViewController.swift
//  CoreDataDemo
//
//  Created by Alexey Efimov on 10.05.2021.
//

import UIKit

protocol TaskViewControllereDelegate {
    func reloadData()
}

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
    
    @objc private func addNewTask() {
        let taskVC = TaskViewController()
        taskVC.delegate = self
        present(taskVC, animated: true)
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
        
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
                let deletedTask = self.tasks[indexPath.row]
                
                self.tasks.remove(at: indexPath.row)
                CoreDataManager.shared.delete(deletedTask)
                CoreDataManager.shared.saveContext()
                tableView.deleteRows(at: [indexPath], with: .bottom)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
    
    // MARK: - TaskViewControllerDelegate
    extension TaskListViewController: TaskViewControllereDelegate {
        func reloadData() {
            fetchData()
            tableView.reloadData()
        }
    }

