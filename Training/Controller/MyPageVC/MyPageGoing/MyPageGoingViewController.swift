//
//  MyPageGoingViewController.swift
//  Training
//
//  Created by ManhLD on 12/20/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class MyPageGoingViewController: UIViewController {
    


    @IBOutlet weak var noEvents: UILabel!
    @IBOutlet weak var goingTable: UITableView!
    private let refreshControl = UIRefreshControl()
    var alertLoading = UIAlertController()
    let status = 1
    var goingEvents : [MyPageGoingResDatabase] = []
    let userToken = UserDefaults.standard.string(forKey: "userToken")
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        alertLoading.createAlertLoading(target: self, isShowLoading: true)
        getListGoingEvent()
        checkEvent()
    }
    
    func checkEvent() {
        if realm.objects(MyPageGoingResDatabase.self).toArray(ofType: MyPageGoingResDatabase.self) == [] {
            noEvents.isHidden = false
        } else {
            noEvents.isHidden = true
        }
    }
    
    func setupView() {
        noEvents.isHidden = true
        goingTable.delegate = self
        goingTable.dataSource = self
        goingTable.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        if #available(iOS 10.0, *) {
            self.goingTable.refreshControl = refreshControl
        } else {
            self.goingTable.addSubview(refreshControl)
        }
            self.refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
    }
    
    @objc func updateData() {
       getListGoingEvent()
        refreshControl.endRefreshing()
    }
    
    func updateObject() {
        let list = RealmDataBaseQuery.getInstance.getObjects(type: MyPageGoingResDatabase.self)!.toArray(ofType: MyPageGoingResDatabase.self)
        goingEvents = list
    }
       
       
    func deleteObject() {
        let list = realm.objects(MyPageGoingResDatabase.self).toArray(ofType: MyPageGoingResDatabase.self)
        try! realm.write {
            realm.delete(list)
        }
    }
    
    func handleLogOut() {
        isLoginVC = true
        UserDefaults.standard.removeObject(forKey: "userToken")
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    
    func getListGoingEvent() {
        if userToken == nil {
            ToastView.shared.short(self.view, txt_msg: "You need to login first !")
        } else {
            let headers = [ "Authorization": "Bearer \(userToken!)",
                            "Content-Type": "application/json"  ]
            getDataService.getInstance.getMyEventGoing(status: self.status, headers: headers) { (json, errCode) in
                if errCode == 1 {
                    self.alertLoading.createAlertWithHandle(target: self, title: "Login session expired", message: "Please re-login !", titleBtn: "OK") {
                        self.handleLogOut()
                    }
                    self.alertLoading.createAlertLoading(target: self, isShowLoading: false)
                } else if errCode == 2 {
                    let data = json!
                    self.deleteObject()
                    self.goingEvents.removeAll()
                    _ = data.array?.forEach({ (goingEvents) in
                    let goingEvents = MyPageGoingResDatabase(id: goingEvents["id"].intValue, photo: goingEvents["photo"].stringValue, name: goingEvents["name"].stringValue, descriptionHtml: goingEvents["description_html"].stringValue, scheduleStartDate: goingEvents["schedule_start_date"].stringValue, scheduleEndDate: goingEvents["schedule_end_date"].stringValue, scheduleStartTime: goingEvents["schedule_start_time"].stringValue, scheduleEndTime: goingEvents["schedule_end_time"].stringValue, schedulePermanent: goingEvents["schedule_permanent"].stringValue, goingCount: goingEvents["going_count"].intValue)
                        RealmDataBaseQuery.getInstance.addData(object: goingEvents)
                })
                    self.updateObject()
                    self.goingTable.reloadData()
                    self.alertLoading.createAlertLoading(target: self, isShowLoading: false)
                }  else {
                    self.updateObject()
                    self.goingTable.reloadData()
                    self.alertLoading.createAlertLoading(target: self, isShowLoading: false)
                }
            }
        }
    }
}

extension MyPageGoingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goingEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = goingTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let queue = DispatchQueue(label: "loadImageGoing")
        queue.async {
            DispatchQueue.main.async {
                cell.imgTimer.image = UIImage(named: "Group15")
                cell.date.textColor = UIColor(rgb: 0x5D20CD)
                cell.imgNews.image = UIImage(data: self.goingEvents[indexPath.row].photo)
            }
        }
        cell.date.text = "\(goingEvents[indexPath.row].scheduleStartDate) - \(goingEvents[indexPath.row].goingCount) people going"
        cell.title.text = goingEvents[indexPath.row].name
        cell.lblDes.text = goingEvents[indexPath.row].descriptionHtml
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let vc = EventDetailController(nibName: "EventDetailView", bundle: nil)
        vc.id = goingEvents[indexPath.row + 1].id
        present(vc, animated: true, completion: nil)
    }
    
}
