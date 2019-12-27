//
//  RealDataBaseQuery.swift
//  ReadBookXIB
//
//  Created by ManhLD on 11/15/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation
import RealmSwift


class RealmDataBaseQuery {
   
    let realm = try! Realm()
    
    class var getInstance: RealmDataBaseQuery {
        struct Static {
           static let instance: RealmDataBaseQuery = RealmDataBaseQuery()
       }
        return Static.instance
    }
    
    public func addData(object: Object) {
        try! self.realm.write {
            self.realm.add(object)
        }
    }
    
    public func deleteAllData() {
        try! self.realm.write {
            self.realm.deleteAll()
        }
    }


    public func deleteData(object: Object) {
        try! self.realm.write {
            self.realm.delete(object)
        }
    }
    
    public func deleteListObject(object: Object.Type) {
        let list = realm.objects(object).toArray(ofType: object)
        try! self.realm.write {
            self.realm.delete(list)
        }
    }

    public func getObjects(type: Object.Type) -> Results<Object>? {
          return realm.objects(type)
      }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
