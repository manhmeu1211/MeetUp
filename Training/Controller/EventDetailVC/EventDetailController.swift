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

    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet var swipeGes: UISwipeGestureRecognizer!
    
    private let realm = try! Realm()
    private var eventDetail = EventDetail()
    private var eventsNear : [EventsNearResponse] = []
    var id : Int?
    private let userToken = UserDefaults.standard.string(forKey: "userToken")
    private var alertLogin = UIAlertController()

    var headers : [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setHeaders()
        getDetailEvent(eventID: id!)
        getListEvent()
    }
    
    private func setUpView() {
        detailTable.dataSource = self
        detailTable.delegate = self
        detailTable.register(UINib(nibName: "ImgDetailCell", bundle: nil), forCellReuseIdentifier: "ImgDetailCell")
        detailTable.register(UINib(nibName: "TextAreaCell", bundle: nil), forCellReuseIdentifier: "TextAreaCell")
        detailTable.register(UINib(nibName: "DetailVenueCell", bundle: nil), forCellReuseIdentifier: "DetailVenueCell")
        detailTable.register(UINib(nibName: "DetailNearCell", bundle: nil), forCellReuseIdentifier: "DetailNearCell")
        detailTable.register(UINib(nibName: "ButtonFooterCell", bundle: nil), forCellReuseIdentifier: "ButtonFooterCell")
        detailTable.rowHeight = UITableView.automaticDimension
        detailTable.allowsSelection = false
        detailTable.showsVerticalScrollIndicator = false
        self.tabBarController?.tabBar.isHidden = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    private func setHeaders() {
        if userToken == nil {
            headers = [ "Authorization": "No Auth",
                        "Content-Type": "application/json"  ]
        } else {
            headers = [ "Authorization": "Bearer " + userToken!,
                        "Content-Type": "application/json"  ]
        }
    }
    
    private func checkLoggedIn() -> Bool {
        if userToken != nil {
            return true
        }
        return false
    }

    
    private func handleLoginView() {
         isLoginVC = true
         let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
         UIApplication.shared.windows.first?.rootViewController = vc
         UIApplication.shared.windows.first?.makeKeyAndVisible()
     }
    
    private func goingEvent() {
        let params = ["status": 1, "event_id": id! ]
        getDataService.getInstance.doUpdateEvent(params: params, headers: headers) { (json, errcode) in
            if errcode == 1 {
                self.alertLogin.createAlert(target: self, title: "Success", message: "Error, please re-login", titleBtn: "OK")
            } else if errcode == 2 {
                self.alertLogin.createAlert(target: self, title: "Success", message: "You're going this event", titleBtn: "OK")
                 self.getDetailEvent(eventID: self.id!)
            } else {
                ToastView.shared.short(self.view, txt_msg: "Check your connection")
            }
        }
    }
    
    private func wentEvent() {
        let params = ["status": 2, "event_id": id! ]
        getDataService.getInstance.doUpdateEvent(params: params, headers: headers) { (json, errcode) in
            if errcode == 1 {
                self.alertLogin.createAlert(target: self, title: "Success", message: "Error, please re-login", titleBtn: "OK")
            } else if errcode == 2 {
                self.alertLogin.createAlert(target: self, title: "Success", message: "You went this event", titleBtn: "OK")
                self.getDetailEvent(eventID: self.id!)
            } else {
                ToastView.shared.short(self.view, txt_msg: "Check your connection")
            }
        }
    }
    
    private func getDetailEvent(eventID : Int) {
        print("getData")
        getDataService.getInstance.getEventDetail(idEvent: eventID, headers: self.headers) { (eventDetail, errcode) in
            if errcode == 1 {
                ToastView.shared.short(self.view, txt_msg: "You need to login first")
                self.alertLogin.createAlertLoading(target: self, isShowLoading: false)
            } else if errcode == 2 {
                self.eventDetail = eventDetail
                self.detailTable.reloadData()
            } else {
                self.alertLogin.createAlert(target: self, title: "No internet connection", message: nil, titleBtn: "OK")
            }
        }
    }
    

    private func getListEvent() {
        let usertoken = UserDefaults.standard.string(forKey: "userToken")
        let headers = [ "Authorization": "Bearer \(usertoken!)",
        "Content-Type": "application/json"  ]
        getDataService.getInstance.getListNearEvent(radius: 10, longitue: self.eventDetail.longValue, latitude: self.eventDetail.latValue, header: headers) { (eventsNear, anotionLC ,errcode) in
            if errcode == 1 {
                print("Failed")
            } else if errcode == 2 {
                self.eventsNear = eventsNear
            } else {
                print("Failed")
            }
        }
    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            id! += 1
            getDetailEvent(eventID: id!)
        } else if gesture.direction == .right {
            id! -= 1
            getDetailEvent(eventID: id!)
        }
    }
    
    @IBAction func backtoHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension EventDetailController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
             let cell = detailTable.dequeueReusableCell(withIdentifier: "ImgDetailCell", for: indexPath) as! ImageDetailCell
             let queue = DispatchQueue(label: "loadImageDetail")
             queue.async {
                 DispatchQueue.main.async {
                     cell.imgDetail.image = UIImage(data: self.eventDetail.photo)
                 }
             }
            
             cell.detailTitle.text = eventDetail.name
             if eventDetail.goingCount == 0 {
                 cell.detailDate.text = "\(eventDetail.scheduleStartDate) "
             } else {
                 cell.detailDate.text = "\(eventDetail.scheduleStartDate) - \(eventDetail.goingCount) people going"
             }
             
             if eventDetail.mystatus == 1 {
                DispatchQueue.main.async {
                    cell.imgStar.image = UIImage(named: "icon_starRed")
                    cell.status.text = "Can participate"
                    cell.status.textColor = UIColor(rgb: 0xC63636)
                    cell.backGroundStatus.backgroundColor = UIColor(rgb: 0xF9EBEB)
                }
             } else {
                DispatchQueue.main.async {
                    cell.imgStar.image = UIImage(named: "icon_starGreen")
                    cell.status.text = "Joined"
                    cell.status.textColor = UIColor(rgb: 0xE5F9F4)
                    cell.backGroundStatus.backgroundColor = UIColor(rgb: 0x00C491)
                }
             }

             return cell
        case 1:
            let cell = detailTable.dequeueReusableCell(withIdentifier: "TextAreaCell", for: indexPath) as! TextAreaCell
            cell.txtView.text = eventDetail.descriptionHtml.replacingOccurrences(of: "[|<>/]", with: "", options: [.regularExpression])
            return cell
        case 2:
            let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailVenueCell", for: indexPath) as! DetailVenueCell
            cell.btnFollow.isHidden = false
            cell.vnName.text = "Venue: "
            cell.vnDetail.text = eventDetail.vnName
            cell.btnFollow.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
            if eventDetail.mystatus == 2 {
                cell.btnFollow.setTitle("Followed", for: .normal)
            }
            return cell
        case 3:
            let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailVenueCell", for: indexPath) as! DetailVenueCell
            cell.btnFollow.isHidden = true
            cell.vnName.text = "Genre: "
            cell.vnDetail.text = eventDetail.nameGenre
            return cell
        case 4:
            let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailVenueCell", for: indexPath) as! DetailVenueCell
             cell.btnFollow.isHidden = true
             cell.vnName.text = "Location: "
             cell.vnDetail.text = eventDetail.vnLocation
             return cell
        case 6:
            let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailNearCell", for: indexPath) as! DetailNearCell
            cell.updateData(eventLoaded: eventsNear)
            return cell
        case 7:
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
        default:
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
