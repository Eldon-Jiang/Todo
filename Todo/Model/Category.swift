//
//  Category.swift
//  Todo
//
//  Created by Eldon Jiang on 2019-01-11.
//  Copyright © 2019 Eldon Jiang. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated: Date = Date()
    let items = List<Item>()
}
