//
//  EventDetailController.swift
//  Training
//
//  Created by ManhLD on 12/20/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class EventDetailController: UIViewController {
    
    let realm = try! Realm()
 
    
    @IBOutlet weak var detailTable: UITableView!
    
    var eventDetail = EventDetail()
    var id : Int?
    let userToken = UserDefaults.standard.string(forKey: "userToken")
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self)
        setUpView()
        getDetailEvent()
    }
    
    func setUpView() {
        detailTable.dataSource = self
        detailTable.delegate = self
        detailTable.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        detailTable.register(UINib(nibName: "TextAreaCell", bundle: nil), forCellReuseIdentifier: "TextAreaCell")
        detailTable.register(UINib(nibName: "DetailVenueCell", bundle: nil), forCellReuseIdentifier: "DetailVenueCell")
        detailTable.register(UINib(nibName: "DetailNearCell", bundle: nil), forCellReuseIdentifier: "DetailNearCell")
        detailTable.register(UINib(nibName: "ButtonFooterCell", bundle: nil), forCellReuseIdentifier: "ButtonFooterCell")
        detailTable.rowHeight = UITableView.automaticDimension
        detailTable.allowsSelection = false
    }
    
    
    func checkLoggedIn() -> Bool {
        if userToken != nil {
            return true
        }
        return false
    }
     
    func deleteObject() {
       let list = realm.objects(EventDetail.self).toArray(ofType: EventDetail.self)
        try! realm.write {
            realm.delete(list)
        }
    }
    
    func getDetailEvent() {
        let usertoken = UserDefaults.standard.string(forKey: "userToken")

        let headers = [ "Authorization": "Bearer \(usertoken!)",
                        "Content-Type": "application/json"  ]
        
        getDataService.getInstance.getEventDetail(idEvent: id!, headers: headers) { (json, errcode) in
            if errcode == 1 {
                print("Lỗi")
            } else if errcode == 2 {
                self.deleteObject()
//                self.eventDetail.removeAll()
                let detail = json!
                let detailVenue = detail["venue"]
                let detailGenre = detail["category"]
                print(detailVenue)
                print(detailGenre)
              
                self.eventDetail = EventDetail(id: detail["id"].intValue, photo: detail["photo"].stringValue, name: detail["name"].stringValue, descriptionHtml: detail["description_html"].stringValue, scheduleStartDate: detail["schedule_start_date"].stringValue, scheduleEndDate: detail["schedule_end_date"].stringValue, scheduleStartTime: detail["schedule_start_time"].stringValue, scheduleEndTime: detail["schedule_end_time"].stringValue, schedulePermanent: detail["schedule_permanent"].stringValue, goingCount: detail["going_count"].intValue, nameGenre: detailGenre["name"].stringValue, vnLocation: detailVenue["contact_address"].stringValue, vnContact: detailVenue["contact_phone"].stringValue, vnName: detailVenue["name"].stringValue)

                RealmDataBaseQuery.getInstance.addData(object: self.eventDetail)
              
                print(self.eventDetail)
                self.detailTable.reloadData()
               
            } else {
                print("Connection")
            }
        }
    }
}

extension EventDetailController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            DispatchQueue.main.async {
                cell.imgTimer.image = UIImage(named: "Group15")
                cell.date.textColor = UIColor(rgb: 0x5D20CD)
                cell.imgNews.image = UIImage(data: self.eventDetail.photo)
            }
            cell.title.text = eventDetail.name
            cell.lblDes.isHidden = true

            if eventDetail.goingCount == 0 {
                cell.date.text = "\(eventDetail.scheduleStartDate) "
            } else {
                cell.date.text = "\(eventDetail.scheduleStartDate) - \(eventDetail.goingCount) people going"
            }
            return cell
        }
        else if indexPath.row == 1 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "TextAreaCell", for: indexPath) as! TextAreaCell
            cell.txtView.text = eventDetail.descriptionHtml
            return cell
        } else if indexPath.row == 2 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailVenueCell", for: indexPath) as! DetailVenueCell
            cell.btnFollow.isHidden = false
            cell.vnName.text = "Venue: "
            cell.vnDetail.text = eventDetail.vnName
            cell.btnFollow.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
            return cell
        }  else if indexPath.row == 3 {
           let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailVenueCell", for: indexPath) as! DetailVenueCell
            cell.btnFollow.isHidden = true
            cell.vnName.text = "Genre: "
            cell.vnDetail.text = eventDetail.nameGenre
            return cell
        } else if indexPath.row == 4 {
           let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailVenueCell", for: indexPath) as! DetailVenueCell
            cell.btnFollow.isHidden = true
            cell.vnName.text = "Location: "
            cell.vnDetail.text = eventDetail.vnLocation
            return cell
        } else if indexPath.row == 6  {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailNearCell", for: indexPath) as! DetailNearCell
           
            return cell
        } else if indexPath.row == 7  {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "ButtonFooterCell", for: indexPath) as! ButtonFooterCell
            if checkLoggedIn() == true {
                cell.btnWent.addTarget(self, action: #selector(handleWent), for: UIControl.Event.touchUpInside)
                cell.btnGoing.addTarget(self, action: #selector(handleGoing), for: UIControl.Event.touchUpInside)
            } else {
                cell.btnWent.isEnabled = false
                cell.btnGoing.isEnabled = false
            }
            
            return cell
        } else {
           let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailVenueCell", for: indexPath) as! DetailVenueCell
            cell.btnFollow.isHidden = true
            cell.vnName.text = "Contact: "
            cell.vnDetail.text = eventDetail.vnContact
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else if indexPath.row == 1 {
            return UITableView.automaticDimension
        } else if indexPath.row == 2 {
            return 100
        } else if indexPath.row == 7  {
            return 50
        } else if indexPath.row == 6  {
            return 150
        } else {
            return 50
        }
    }
    
    @objc func handleFollow() {
        print("follow")
    }
    
    @objc func handleGoing() {
           print("going")
       }
    
    @objc func handleWent() {
           print("went")
       }
    
}
