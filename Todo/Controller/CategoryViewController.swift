//
//  CategoryViewController.swift
//  Todo
//
//  Created by Eldon Jiang on 2019-01-08.
//  Copyright © 2019 Eldon Jiang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    //Declare instance variables here
    var categoryArray: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateColor(color: FlatWhite())
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = categoryArray?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.backgroundColor = UIColor(hexString: item.colorCode)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: item.colorCode)!, returnFlat: true)
        } else {
            cell.textLabel?.text = "Nothing available"
        }
        
        return cell
    }
    
    //MARK: - Override removeIt()
    
    override func removeIt(indexPath: IndexPath) {
        if let tobeRemoved = categoryArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(tobeRemoved)
                }
            } catch {
                print("Error in deleting category \(error)")
            }
        }
    }
    
    //MARK: - Segue related
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    //MARK: - Save and read data
    func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Erron in saving. \(error)")
        }
    }
    
    func loadData() {
        categoryArray = realm.objects(Category.self).sorted(byKeyPath: "colorCode", ascending: false)
        tableView.reloadData()
    }
    
    //MARK: - Add data
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var tmpTextField = UITextField()
        
        let alert = UIAlertController(title: "Add", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if tmpTextField.text != "" {
                let newCate = Category()
                newCate.name = tmpTextField.text!
                newCate.colorCode = RandomFlatColorWithShade(.light).hexValue()
                self.saveData(category: newCate)
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

