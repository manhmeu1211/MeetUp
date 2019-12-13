//
//  CategoriesDatabase.swift
//  Training
//
//  Created by ManhLD on 12/12/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation
import RealmSwift


class CategoriesResDatabase: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var slug = ""
    @objc dynamic var parentId = 0
  
 
    convenience init(id: Int, name :String , slug : String, parentId: Int) {
        self.init()
        self.id = id
        self.name = name
        self.slug = slug
        self.parentId = parentId
    }
}

