//
//  CategoriesDatabase.swift
//  Training
//
//  Created by ManhLD on 12/12/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


class CategoriesResDatabase: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var slug = ""
    @objc dynamic var parentId = 0
  
 
    convenience init(cate: JSON) {
        self.init()
        self.id = cate["id"].intValue
        self.name = cate["name"].stringValue
        self.slug = cate["slug"].stringValue
        self.parentId = cate["parent_id"].intValue
    }
}

