//
//  Category.swift
//  register1
//
//  Created by Sourabh kehar on 2020-04-26.
//  Copyright © 2020 Sourabh kehar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
