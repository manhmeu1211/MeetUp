//
//  PopularsViewController.swift
//  Training
//
//  Created by ManhLD on 12/11/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class PopularsViewController: UIViewController {
    
    
    // MARK: - Outlet
    @IBOutlet weak var popularsTable: UITableView!
    
    // MARK: - Varribles
    var alertLoading = UIAlertController()
    let refreshControl = UIRefreshControl()
    var popularResponse : [PopularsResDatabase] = []
    var currentPage = 1
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         if detechDailyFirstLaunch() == false {
            alertLoading.createAlertLoading(target: self, isShowLoading: true)
            updateObject()
        } else {
            alertLoading.createAlertLoading(target: self, isShowLoading: true)
            upDateDataV2()
        }
        setUpTable()
    }
    
    // MARK: - Function check before get data
    
    func detechDailyFirstLaunch() -> Bool {
           let today = NSDate().formatted
           if (UserDefaults.standard.string(forKey: "FIRSTLAUNCHPOPULARS") == today) {
               print("already launched")
               return false
           } else {
               print("first launch")
               UserDefaults.standard.setValue(today, forKey:"FIRSTLAUNCHPOPULARS")
               return true
           }
       }
    
    // MARK: - Function set up table and get data
 
    func setUpTable() {
        popularsTable.dataSource = self
        popularsTable.delegate = self
        popularsTable.rowHeight = UITableView.automaticDimension
        popularsTable.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
          if #available(iOS 10.0, *) {
                 self.popularsTable.refreshControl = refreshControl
             } else {
                 self.popularsTable.addSubview(refreshControl)
             }
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing data")
        refreshControl.addTarget(self, action: #selector(upDateDataV2), for: .valueChanged)
    }
    
 
    @objc func upDateDataV2() {
        getListPopularData(isLoadMore: false, page: currentPage)
        refreshControl.endRefreshing()
    }
    
    
    func updateObject() {
        self.popularResponse = RealmDataBaseQuery.getInstance.getObjects(type: PopularsResDatabase.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: PopularsResDatabase.self)
        alertLoading.createAlertLoading(target: self, isShowLoading: false)
    }
    
    
    func deleteObject() {
          let list = realm.objects(PopularsResDatabase.self).toArray(ofType: PopularsResDatabase.self)
          try! realm.write {
              realm.delete(list)
          }
      }

    
    func getListPopularData(isLoadMore : Bool, page : Int) {
        getDataService.getInstance.getListPopular(pageIndex: page, pageSize : 10) { (data, isSuccess) in
            if isSuccess == 1 {
                let result = data!
                if isLoadMore == false {
                    self.deleteObject()
                    self.popularResponse.removeAll()
                    _ = result.array?.forEach({ (populars) in
                        let populars = PopularsResDatabase(id: populars["id"].intValue, photo: populars["photo"].stringValue, name: populars["name"].stringValue, descriptionHtml: populars["description_html"].stringValue, scheduleStartDate: populars["schedule_start_date"].stringValue, scheduleEndDate: populars["schedule_end_date"].stringValue, scheduleStartTime: populars["schedule_start_time"].stringValue, scheduleEndTime: populars["schedule_end_time"].stringValue, schedulePermanent: populars["schedule_permanent"].stringValue, goingCount: populars["going_count"].intValue)
                        RealmDataBaseQuery.getInstance.addData(object: populars)
                    })
                } else {
                    _ = result.array?.forEach({ (populars) in
                        let populars = PopularsResDatabase(id: populars["id"].intValue, photo: populars["photo"].stringValue, name: populars["name"].stringValue, descriptionHtml: populars["description_html"].stringValue, scheduleStartDate: populars["schedule_start_date"].stringValue, scheduleEndDate: populars["schedule_end_date"].stringValue, scheduleStartTime: populars["schedule_start_time"].stringValue, scheduleEndTime: populars["schedule_end_time"].stringValue, schedulePermanent: populars["schedule_permanent"].stringValue, goingCount: populars["going_count"].intValue)
                        RealmDataBaseQuery.getInstance.addData(object: populars)
                    })
                }
                self.updateObject()
                self.popularsTable.reloadData()
                self.alertLoading.createAlertLoading(target: self, isShowLoading: false)
            } else {
                self.updateObject()
                ToastView.shared.short(self.view, txt_msg: "Failed to load data from server")
                print("Failed to load Data")
            }
        }
    }
}

// MARK: - extension Table

extension PopularsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let queue = DispatchQueue(label: "loadImagePop")
        queue.async {
            DispatchQueue.main.async {
                cell.imgTimer.image = UIImage(named: "Group15")
                cell.imgNews.image = UIImage(data: self.popularResponse[indexPath.row].photo)
            }
        }
        cell.date.textColor = UIColor(rgb: 0x5D20CD)
        cell.date.text = "\(popularResponse[indexPath.row].scheduleStartDate) - \(popularResponse[indexPath.row].goingCount) people going"
        cell.title.text = popularResponse[indexPath.row].name
        cell.lblDes.text = popularResponse[indexPath.row].descriptionHtml
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == popularResponse.count - 2 {
            self.alertLoading.createAlertLoading(target: self, isShowLoading: true)
            self.getListPopularData(isLoadMore: true, page: self.currentPage + 1 )
            self.currentPage += 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = popularResponse[indexPath.row].id
        let vc = EventDetailController(nibName: "EventDetailView", bundle: nil)
        vc.id = id
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
}
