//
//  PopularsResDatabase.swift
//  Training
//
//  Created by ManhLD on 12/12/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//


import Foundation
import RealmSwift
import SwiftyJSON

class EventDetail: Object {
    
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
    @objc dynamic var nameGenre = ""
    @objc dynamic var vnLocation = ""
    @objc dynamic var vnContact = ""
    @objc dynamic var vnName = ""
    @objc dynamic var latValue = 0.0
    @objc dynamic var longValue = 0.0
    @objc dynamic var mystatus = 0
    
    convenience init(id: Int, photo :String , name: String, descriptionHtml : String, scheduleStartDate : String, scheduleEndDate : String, scheduleStartTime: String, scheduleEndTime : String, schedulePermanent : String, goingCount: Int, nameGenre : String, vnLocation : String, vnContact : String, vnName : String ) {
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
        self.vnName = vnName
        self.vnContact = vnContact
        self.vnLocation = vnLocation
        self.nameGenre = nameGenre
    }
    
    
    convenience init(detail : JSON, detailVenue : JSON, detailGenre : JSON) {
        self.init()
        self.id = detail["id"].intValue
        var url = URL(string: detail["photo"].stringValue)
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
        self.name = detail["name"].stringValue
        self.descriptionHtml = detail["description_html"].stringValue
        self.scheduleStartDate = detail["schedule_start_date"].stringValue
        self.scheduleEndDate = detail["schedule_end_date"].stringValue
        self.scheduleStartTime = detail["schedule_start_time"].stringValue
        self.scheduleEndTime = detail["schedule_end_time"].stringValue
        self.schedulePermanent = detail["schedule_permanent"].stringValue
        self.goingCount = detail["going_count"].intValue
        self.vnName = detailVenue["name"].stringValue
        self.vnContact = detailVenue["contact_phone"].stringValue
        self.vnLocation = detailVenue["contact_address"].stringValue
        self.nameGenre = detailGenre["name"].stringValue
        self.latValue = detailVenue["geo_lat"].doubleValue
        self.longValue = detailVenue["geo_long"].doubleValue
        self.mystatus = detail["my_status"].intValue
    }
}

