//
//  CoreDataManager.swift
//  RE_CoreData
//
//  Created by Дэвид Бердников on 27.11.2021.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
        
    // MARK: - CoreDataStack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RE_CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    func fetchData(comletion: (Result<[Task], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            comletion(.success(tasks))
        } catch let error {
            comletion(.failure(error))
        }
    }
    
    func save(_ taskName: String, comletion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = taskName
        
        comletion(task)
        saveContext()
    }
    
    func edit(_ task: Task, newName: String) {
        task.title = newName
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
    }
    
    // MARK: - Save Context Coew Data
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}


