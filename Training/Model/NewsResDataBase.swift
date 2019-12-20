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
        var urlImg = URL(string: thumbImg)
        let image = UIImage(named: "noImage.png")
        
        if urlImg != nil {
            do {
                self.thumbImg = try Data(contentsOf: urlImg!)
            } catch {
                self.thumbImg = (image?.pngData())!
            }
        } else {
            urlImg = URL(string: "https://agdetail.image-gmkt.com/105/092/472092105/img/cdn.shopify.com/s/files/1/0645/2551/files/qoo10_03ed8677a499a4fbc2e046a81ee99c7c.png")
        }
        do {
            self.thumbImg = try Data(contentsOf: urlImg!)
        } catch {
            self.thumbImg = (image?.pngData())!
        }
        self.author = author
        self.publishdate = publishdate
        self.url = url
    }
}
