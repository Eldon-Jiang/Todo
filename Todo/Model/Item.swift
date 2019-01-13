//
//  File.swift
//  Todo
//
//  Created by Eldon Jiang on 2019-01-11.
//  Copyright © 2019 Eldon Jiang. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
