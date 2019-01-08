//
//  ListTableViewController.swift
//  Todo
//
//  Created by 江尚乘 on 2019-01-01.
//  Copyright © 2019 Eldon Jiang. All rights reserved.
//

import UIKit
import CoreData
class ListTableViewController: UITableViewController {

    // Declare instance variables here
    var todoArray: [Item] = [Item]()
    let defaults: UserDefaults = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(filePath)
        loadData()
    }
    
    // MARK: - CoreData save and read
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error in saving. \(error)")
        }
    }

    func loadData(Request fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            todoArray = try context.fetch(fetchRequest) as [Item]
        } catch {
            print("Error in reading. \(error)")
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view related
    
    //TODO: datasource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)

        cell.textLabel?.text = todoArray[indexPath.row].title
        cell.accessoryType = todoArray[indexPath.row].done ? .checkmark : .none

        return cell
    }
    
    //TODO: selected cell methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        //If were to delete item after being selected
//        context.delete(todoArray[indexPath.row])
//        todoArray.remove(at: indexPath.row)
        
        todoArray[indexPath.row].done = !todoArray[indexPath.row].done
        saveData()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }


    //TODO: add new item in
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var tmpTextField = UITextField()
        
        let alert = UIAlertController(title: "Add", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if tmpTextField.text != "" {
                let newItem = Item(context: self.context)
                newItem.title = tmpTextField.text!
                newItem.done = false
                
                self.todoArray.append(newItem)
                self.saveData()
            }
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.tableView.reloadData()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Work on Todo project ..."
            tmpTextField = textField
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK: - Search Bar Related

extension ListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let sort = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sort]
        
        loadData(Request: fetchRequest)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
