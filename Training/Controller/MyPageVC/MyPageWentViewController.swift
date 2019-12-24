//
//  MyPageWentViewController.swift
//  Training
//
//  Created by ManhLD on 12/20/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class MyPageWentViewController: UIViewController {

    @IBOutlet weak var wentTable: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    let userToken = UserDefaults.standard.string(forKey: "userToken")
    let status = 2
    let realm = try! Realm()
    var wentEvents : [MyPageWentResDatabase] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if userToken != nil {
            getListGoingWent()
        } else {
            print("data loaded")
        }
    }
    
    func setupView() {
          wentTable.delegate = self
          wentTable.dataSource = self
          wentTable.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
          self.loading.handleLoading(isLoading: true)
      }
    
    
    func updateObject() {
             self.wentEvents = RealmDataBaseQuery.getInstance.getObjects(type: MyPageWentResDatabase.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: MyPageWentResDatabase.self)
         }
         
         
      func deleteObject() {
          let list = realm.objects(MyPageWentResDatabase.self).toArray(ofType: MyPageWentResDatabase.self)
          try! realm.write {
              realm.delete(list)
          }
      }

       func getListGoingWent() {
           let usertoken = UserDefaults.standard.string(forKey: "userToken")
           if usertoken == nil {
               self.loading.handleLoading(isLoading: false)
               ToastView.shared.short(self.view, txt_msg: "Not need to login first !")
           } else {
               let headers = [ "Authorization": "Bearer \(usertoken!)",
                               "Content-Type": "application/json"  ]
             
            getDataService.getInstance.getMyEventWent(status: self.status, headers: headers) { (json, errCode) in
                    if errCode == 1 {
                        ToastView.shared.short(self.view, txt_msg: "Cannot load data from server!")
                    } else if errCode == 2 {
                        let data = json!
                        self.deleteObject()
                        self.wentEvents.removeAll()
                        _ = data.array?.forEach({ (goingEvents) in
                        let goingEvents = MyPageWentResDatabase(id: goingEvents["id"].intValue, photo: goingEvents["photo"].stringValue, name: goingEvents["name"].stringValue, descriptionHtml: goingEvents["description_html"].stringValue, scheduleStartDate: goingEvents["schedule_start_date"].stringValue, scheduleEndDate: goingEvents["schedule_end_date"].stringValue, scheduleStartTime: goingEvents["schedule_start_time"].stringValue, scheduleEndTime: goingEvents["schedule_end_time"].stringValue, schedulePermanent: goingEvents["schedule_permanent"].stringValue, goingCount: goingEvents["going_count"].intValue)
                        RealmDataBaseQuery.getInstance.addData(object: goingEvents)
                    })
                        self.updateObject()
                        self.wentTable.reloadData()
                        self.loading.handleLoading(isLoading: false)
                    }  else {
                        self.updateObject()
                        self.wentTable.reloadData()
                        ToastView.shared.short(self.view, txt_msg: "Check your connetion !")
                    }
                }
            }
        }
    }


extension MyPageWentViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wentEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wentTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let queue = DispatchQueue(label: "getListGoingEvent")
        queue.async {
            DispatchQueue.main.async {
                cell.imgTimer.image = UIImage(named: "Group15")
                cell.date.textColor = UIColor(rgb: 0x5D20CD)
                cell.imgNews.image = UIImage(data: self.wentEvents[indexPath.row].photo)
            }
        }
        cell.date.text = "\(wentEvents[indexPath.row].scheduleStartDate) - \(wentEvents[indexPath.row].goingCount) people going"
        cell.title.text = wentEvents[indexPath.row].name
        cell.lblDes.text = wentEvents[indexPath.row].descriptionHtml
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let id = wentEvents[indexPath.row].id
        let vc = EventDetailController(nibName: "EventDetailView", bundle: nil)
        vc.id = id
        present(vc, animated: true, completion: nil)
    }

}
