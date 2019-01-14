//
//  SwipeTableViewController.swift
//  Todo
//
//  Created by Eldon Jiang on 2019-01-13.
//  Copyright © 2019 Eldon Jiang. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "swipeCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    // MARK: - Swipe cell delegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.removeIt(indexPath: indexPath)
        }
        deleteAction.image = UIImage(named: "Trash")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func removeIt(indexPath: IndexPath) {
        print("Supposed to be override by subclass.")
    }
    
    //MARK: - Update color
    
    func updateColor(color: UIColor) {
        guard let nav = navigationController?.navigationBar else {
            fatalError("No navigation bar")
        }
        let lightColor:UIColor = color.lighten(byPercentage: CGFloat(1)/CGFloat(10)) ?? FlatWhite()
        nav.barTintColor = lightColor
        nav.tintColor = ContrastColorOf(lightColor, returnFlat: true)
        nav.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(lightColor, returnFlat: true)]
        
    }
}
