//
//  ViewController.swift
//  RE_CoreData
//
//  Created by Дэвид Бердников on 25.11.2021.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarApearence = UINavigationBarAppearance()
        navBarApearence.configureWithOpaqueBackground()
        
        navBarApearence.backgroundColor = #colorLiteral(red: 0.002558406442, green: 0.4522010684, blue: 0.9921777844, alpha: 1)
        navBarApearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarApearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarApearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApearence
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        let taskVC = TaskViewController()
        present(TaskViewController(), animated: true)
    }
    
    
}
