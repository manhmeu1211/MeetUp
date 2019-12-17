//
//  NewsResDataBase.swift
//  Training
//
//  Created by ManhLD on 12/12/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//
//


import Foundation
import RealmSwift

class NewsDataResponse: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var feed = ""
    @objc dynamic var title = ""
    @objc dynamic var thumbImg = Data()
    @objc dynamic var author = ""
    @objc dynamic var publishdate = ""
    @objc dynamic var url = ""
 
    
    convenience init(id: Int, feed :String , title: String, thumbImg : String, author : String, publishdate : String, url: String) {
        self.init()
        self.id = id
        self.feed = feed
        self.title = title
        guard let urlImg = URL(string: thumbImg) else { return }
        let image = UIImage(named: "noImage.png")
        do {
        self.thumbImg = try Data(contentsOf: urlImg)
        } catch {
        self.thumbImg = (image?.pngData())!
        }
        self.author = author
        self.publishdate = publishdate
        self.url = url
    }
}
