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
    var todoArray: [String] = []
    let defaults: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let todos = defaults.array(forKey: "todoArray") as? [String] {
            todoArray = todos
        }
        
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

        cell.textLabel?.text = todoArray[indexPath.row]

        return cell
    }
    
    //TODO: selected cell methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(todoArray[indexPath.row])")
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


    //MARK: Add new item
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var tmpTextField = UITextField()
        
        let alert = UIAlertController(title: "Add", message: "Add item to list.", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if tmpTextField.text != "" {
                self.todoArray.append(tmpTextField.text!)
                self.defaults.set(self.todoArray, forKey: "todoArray")
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
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
