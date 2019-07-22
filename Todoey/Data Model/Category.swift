//
//  Category.swift
//  Todoey
//
//  Created by MacBook Air on 09/07/2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
