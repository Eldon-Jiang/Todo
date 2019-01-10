//
//  CategoryViewController.swift
//  Todo
//
//  Created by Eldon Jiang on 2019-01-08.
//  Copyright © 2019 Eldon Jiang. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //Declare instance variables here
    var categoryArray: [Category] = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    //MARK: - Segue related
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    //MARK: - Save and read data
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Erron in savaing. \(error)")
        }
    }
    
    func loadData(Request fetchRequest : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(fetchRequest) as [Category]
        } catch {
            print("Error in reading. \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Add data
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var tmpTextField = UITextField()
        
        let alert = UIAlertController(title: "Add", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if tmpTextField.text != "" {
                let newCate = Category(context: self.context)
                newCate.name = tmpTextField.text!
                
                self.categoryArray.append(newCate)
                self.saveData()
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.tableView.reloadData()
        }))
        alert.addTextField { (textField) in
            textField.placeholder = "Study ..."
            tmpTextField = textField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK : - Search bar related

//extension CategoryViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let fetchRequest : NSFetchRequest<Category> = Category.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", searchBar.text!)
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        loadData(Request: fetchRequest)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text!.count == 0 {
//            loadData()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
