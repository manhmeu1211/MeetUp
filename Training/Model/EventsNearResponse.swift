//
//  EventsNearResponse.swift
//  Training
//
//  Created by ManhLD on 12/17/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


class EventsNearResponse: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var photo = Data()
    @objc dynamic var name = ""
    @objc dynamic var descriptionHtml = ""
    @objc dynamic var scheduleStartDate = ""
    @objc dynamic var scheduleEndDate = ""
    @objc dynamic var scheduleStartTime = ""
    @objc dynamic var scheduleEndTime = ""
    @objc dynamic var schedulePermanent = ""
    @objc dynamic var goingCount = 0
    
   convenience init(id: Int, photo :String , name: String, descriptionHtml : String, scheduleStartDate : String, scheduleEndDate : String, scheduleStartTime: String, scheduleEndTime : String, schedulePermanent : String, goingCount: Int ) {
        self.init()
        self.id = id
        var url = URL(string: photo)
        let image = UIImage(named: "noImage.png")
        if url != nil {
            do {
                self.photo = try Data(contentsOf: url!)
            } catch {
                self.photo = (image?.pngData())!
            }
        } else {
            url = URL(string: "https://agdetail.image-gmkt.com/105/092/472092105/img/cdn.shopify.com/s/files/1/0645/2551/files/qoo10_03ed8677a499a4fbc2e046a81ee99c7c.png")
        }
        
        do {
            self.photo = try Data(contentsOf: url!)
        } catch {
        self.photo = (image?.pngData())!
        }
        
        self.name = name
        self.descriptionHtml = descriptionHtml
        self.scheduleStartDate = scheduleStartDate
        self.scheduleEndDate = scheduleEndDate
        self.scheduleStartTime = scheduleStartTime
        self.scheduleEndTime = scheduleEndTime
        self.schedulePermanent = schedulePermanent
        self.goingCount = goingCount
    }
    
    convenience init(events : JSON) {
        self.init()
        self.id = events["id"].intValue
        var url = URL(string: events["photo"].stringValue)
        let image = UIImage(named: "noImage.png")
        if url != nil {
            do {
                self.photo = try Data(contentsOf: url!)
            } catch {
                self.photo = (image?.pngData())!
            }
        } else {
            url = URL(string: "https://agdetail.image-gmkt.com/105/092/472092105/img/cdn.shopify.com/s/files/1/0645/2551/files/qoo10_03ed8677a499a4fbc2e046a81ee99c7c.png")
        }
        
        do {
            self.photo = try Data(contentsOf: url!)
        } catch {
            self.photo = (image?.pngData())!
        }
        
        self.name = events["name"].stringValue
        self.descriptionHtml = events["description_html"].stringValue
        self.scheduleStartDate = events["schedule_start_date"].stringValue
        self.scheduleEndDate = events["schedule_end_date"].stringValue
        self.scheduleStartTime = events["schedule_start_time"].stringValue
        self.scheduleEndTime = events["schedule_end_time"].stringValue
        self.schedulePermanent = events["schedule_permanent"].stringValue
        self.goingCount = events["going_count"].intValue
    }
}
