//
//  ListTableViewController.swift
//  Todo
//
//  Created by 江尚乘 on 2019-01-01.
//  Copyright © 2019 Eldon Jiang. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    // Declare instance variables here
    var todoArray: [Item] = [Item]()
    let defaults: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testItem = Item()
        testItem.title = "Eat apple"
        todoArray.append(testItem)
        
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
        
        todoArray[indexPath.row].done = !todoArray[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }


    //MARK: Add new item
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var tmpTextField = UITextField()
        
        let alert = UIAlertController(title: "Add", message: "Add item to list.", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if tmpTextField.text != "" {
                let newItem = Item()
                newItem.title = tmpTextField.text!
                newItem.done = false
                self.todoArray.append(newItem)
                
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
