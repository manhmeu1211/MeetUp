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
    var events : [EventsNearResponse] = []
    var id : Int?
    let userToken = UserDefaults.standard.string(forKey: "userToken")
    var alertLogin = UIAlertController()

    var headers : [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getDetailEvent()
        setHeaders()
        getListEvent()
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
        detailTable.showsVerticalScrollIndicator = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setHeaders() {
        if userToken == nil {
            headers = [ "Authorization": "No Auth",
                        "Content-Type": "application/json"  ]
        } else {
            headers = [ "Authorization": "Bearer \(userToken!)",
                        "Content-Type": "application/json"  ]
        }
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
    
    func handleLoginView() {
         isLoginVC = true
         let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
         UIApplication.shared.windows.first?.rootViewController = vc
         UIApplication.shared.windows.first?.makeKeyAndVisible()
     }
    
    func goingEvent() {
        let params = ["status": 1, "event_id": id! ]
        getDataService.getInstance.doUpdateEvent(params: params, headers: headers) { (json, errcode) in
            if errcode == 1 {
                ToastView.shared.short(self.view, txt_msg: "System error")
            } else if errcode == 2 {
                self.alertLogin.createAlert(target: self, title: "Success", message: "You're going this event", titleBtn: "OK")
                 self.getDetailEvent()
            } else {
                ToastView.shared.short(self.view, txt_msg: "Check your connection")
            }
        }
    }
    
    func wentEvent() {
        let params = ["status": 2, "event_id": id! ]
        getDataService.getInstance.doUpdateEvent(params: params, headers: headers) { (json, errcode) in
            if errcode == 1 {
                ToastView.shared.short(self.view, txt_msg: "System error")
            } else if errcode == 2 {
                self.alertLogin.createAlert(target: self, title: "Success", message: "You went this event", titleBtn: "OK")
                self.getDetailEvent()
            } else {
                ToastView.shared.short(self.view, txt_msg: "Check your connection")
            }
        }
    }
    
    func getDetailEvent() {
        getDataService.getInstance.getEventDetail(idEvent: self.id!, headers: self.headers) { (json, errcode) in
            if errcode == 1 {
                ToastView.shared.short(self.view, txt_msg: "You need to login first")
                self.alertLogin.createAlertLoading(target: self, isShowLoading: false)
            } else if errcode == 2 {
                self.deleteObject()
                let detail = json!
                let detailVenue = detail["venue"]
                let detailGenre = detail["category"]
                self.eventDetail = EventDetail(id: detail["id"].intValue, photo: detail["photo"].stringValue, name: detail["name"].stringValue, descriptionHtml: detail["description_html"].stringValue, scheduleStartDate: detail["schedule_start_date"].stringValue, scheduleEndDate: detail["schedule_end_date"].stringValue, scheduleStartTime: detail["schedule_start_time"].stringValue, scheduleEndTime: detail["schedule_end_time"].stringValue, schedulePermanent: detail["schedule_permanent"].stringValue, goingCount: detail["going_count"].intValue, nameGenre: detailGenre["name"].stringValue, vnLocation: detailVenue["contact_address"].stringValue, vnContact: detailVenue["contact_phone"].stringValue, vnName: detailVenue["name"].stringValue, latValue: detailVenue["geo_lat"].doubleValue, longValue: detailVenue["geo_long"].doubleValue, mystatus: detail["my_status"].intValue )
         
                RealmDataBaseQuery.getInstance.addData(object: self.eventDetail)
                self.detailTable.reloadData()
            } else {
                self.alertLogin.createAlert(target: self, title: "No internet connection", message: nil, titleBtn: "OK")
            }
        }
    }
    

    func getListEvent() {
        getDataService.getInstance.getListNearEvent(radius: 5000, longitue: self.eventDetail.longValue, latitude: self.eventDetail.latValue, header: self.headers) { (json, errcode) in
                if errcode == 1 {
                    self.events.removeAll()
                    let anotionLC = json!
                    _ = anotionLC.array?.forEach({ (events) in
                        let events = EventsNearResponse(id: events["id"].intValue, photo: events["photo"].stringValue, name: events["name"].stringValue, descriptionHtml: events["description_html"].stringValue, scheduleStartDate: events["schedule_start_date"].stringValue, scheduleEndDate: events["schedule_end_date"].stringValue, scheduleStartTime: events["schedule_start_time"].stringValue, scheduleEndTime: events["schedule_end_time"].stringValue, schedulePermanent: events["schedule_permanent"].stringValue, goingCount: events["going_count"].intValue)
                    self.events.append(events)
                    })
                } else {
                    print("failed")
                }
            }
      }

    
    
    @IBAction func backtoHome(_ sender: Any) {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension EventDetailController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            let queue = DispatchQueue(label: "loadImageDetail")
            queue.async {
                DispatchQueue.main.async {
                    cell.imgTimer.image = UIImage(named: "Group15")
                    cell.date.textColor = UIColor(rgb: 0x5D20CD)
                    cell.imgNews.image = UIImage(data: self.eventDetail.photo)
                }
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
            cell.txtView.text = eventDetail.descriptionHtml.replacingOccurrences(of: "[|<>/]", with: "", options: [.regularExpression])
            return cell
        } else if indexPath.row == 2 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailVenueCell", for: indexPath) as! DetailVenueCell
            cell.btnFollow.isHidden = false
            cell.vnName.text = "Venue: "
            cell.vnDetail.text = eventDetail.vnName
            cell.btnFollow.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
            if eventDetail.mystatus == 2 {
                cell.btnFollow.setTitle("Followed", for: .normal)
            }
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
            cell.updateData(eventLoaded: events)
            return cell
        } else if indexPath.row == 7  {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "ButtonFooterCell", for: indexPath) as! ButtonFooterCell
            cell.btnWent.addTarget(self, action: #selector(handleWent), for: UIControl.Event.touchUpInside)
            cell.btnGoing.addTarget(self, action: #selector(handleGoing), for: UIControl.Event.touchUpInside)
            if checkLoggedIn() == false {
                cell.btnGoing.backgroundColor = UIColor.systemGray6
                cell.btnWent.backgroundColor = UIColor.systemGray6
            } else {
                if eventDetail.mystatus == 1 {
                     cell.btnGoing.backgroundColor = UIColor.red
                } else if eventDetail.mystatus == 2 {
                    cell.btnWent.backgroundColor = UIColor.systemOrange
                    cell.btnWent.isEnabled = false
                    cell.btnGoing.isEnabled = false
                }
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
            return 200
        } else {
            return 50
        }
    }
    
    
    @objc func handleFollow() {
         if checkLoggedIn() == false {
            alertLogin.createAlertWithHandle(target: self, title: "Not logged in", message: "You have to login", titleBtn: "OK") {
                self.handleLoginView()
            }
        }
    }
    
    @objc func handleGoing() {
        if checkLoggedIn() == false {
            alertLogin.createAlertWithHandle(target: self, title: "Not logged in", message: "You have to login", titleBtn: "LOGIN") {
                self.handleLoginView()
            }
        } else {
            if eventDetail.mystatus != 1 {
                self.goingEvent()
            } else {
                ToastView.shared.short(self.view, txt_msg: "Already join this event")
            }
        }
    }
    
    @objc func handleWent() {
        if checkLoggedIn() == false {
            alertLogin.createAlertWithHandle(target: self, title: "Not logged in", message: "You have to login", titleBtn: "LOGIN") {
                self.handleLoginView()
            }
        } else {
            if eventDetail.mystatus != 2 {
                self.wentEvent()
            } else {
                ToastView.shared.short(self.view, txt_msg: "Already join this event")
            }
        }
    }
}
