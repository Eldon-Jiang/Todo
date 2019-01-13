//
//  ListTableViewController.swift
//  Todo
//
//  Created by 江尚乘 on 2019-01-01.
//  Copyright © 2019 Eldon Jiang. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableViewController: SwipeTableViewController {

    // Declare instance variables here
    var todoArray: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory?.name
        loadData()
    }
    
    // MARK: - Realm data save and read

    func loadData() {
        todoArray = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    // MARK: - Table view related
    
    //TODO: datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Item unavailable..."
        }

        return cell
    }
    
    //TODO: selected cell methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Erron toggling item status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Override removeIt()
    
    override func removeIt(indexPath: IndexPath) {
        if let tobeRemoved = todoArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(tobeRemoved)
                }
            } catch {
                print("Error in deleting item \(error)")
            }
        }
    }

    //TODO: add new item in
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var tmpTextField = UITextField()
        
        let alert = UIAlertController(title: "Add", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if tmpTextField.text! != "" {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = tmpTextField.text!
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error in saving new item \(error)")
                    }
                }
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

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        todoArray = todoArray?.filter(predicate).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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
