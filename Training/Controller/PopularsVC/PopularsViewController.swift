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
    private var alertLoading = UIAlertController()
    private let refreshControl = UIRefreshControl()
    private var popularResponse : [PopularsResDatabase] = []
    private var currentPage = 1
    private var isLoadmore : Bool!
    private var changeColor : Int!
    private var userToken = UserDefaults.standard.string(forKey: "userToken")
    private var headers : [String : String] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setHeaders()
        getDataFirstLaunch()
        checkConnection()
    }

    
    // MARK: - Function check before get data
    
    private func checkConnection() {
          NotificationCenter.default.addObserver(self, selector: #selector(NewsViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
         Reach().monitorReachabilityChanges()
      }
      
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let statusConnect = userInfo["Status"] as! String
            print(statusConnect)
        }
        let status = Reach().connectionStatus()
            switch status {
                case .unknown, .offline:
                    isLoadmore = false
                case .online(.wwan):
                    isLoadmore = true
                case .online(.wiFi):
                    isLoadmore = true
            }
    }
    
    private func getDataFirstLaunch() {
        if detechDailyFirstLaunch() == false {
            alertLoading.createAlertLoading(target: self, isShowLoading: true)
            updateObject()
            popularsTable.reloadData()
        } else {
            alertLoading.createAlertLoading(target: self, isShowLoading: true)
            upDateDataV2()
        }
    }
    
    private func detechDailyFirstLaunch() -> Bool {
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
    
    private func setHeaders() {
        if userToken == nil {
            headers = [ "Authorization": "No Auth",
                         "Content-Type": "application/json"  ]
         } else {
             headers = [ "Authorization": "Bearer " + userToken!,
                         "Content-Type": "application/json"  ]
         }
    }
    
    // MARK: - Function set up table and get data
 
    private func setUpTable() {
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
    
    
    private func updateObject() {
        self.popularResponse = RealmDataBaseQuery.getInstance.getObjects(type: PopularsResDatabase.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: PopularsResDatabase.self)
        alertLoading.createAlertLoading(target: self, isShowLoading: false)
    }
    
    
    private func getListPopularData(isLoadMore : Bool, page : Int) {
        getDataService.getInstance.getListPopular(pageIndex: page, pageSize : 10, headers: headers, isLoadmore: isLoadMore) { (popularData, isSuccess) in
            if isSuccess == 1 {
                if isLoadMore == false {
                    self.popularResponse.removeAll()
                    self.popularResponse = popularData
                } else {
                    self.popularResponse = popularData
                }
                self.popularsTable.reloadData()
                self.alertLoading.dismiss(animated: true, completion: nil)
            } else {
                print("Failed to load Data")
                self.dismiss(animated: true, completion: nil)
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
        switch popularResponse[indexPath.row].myStatus {
        case 1:
            DispatchQueue.main.async {
                cell.statusImage.image = UIImage(named: "icon_starRed")
                cell.statusLabel.text = "Can participate"
                cell.statusLabel.textColor = UIColor(rgb: 0xC63636)
                cell.backgroundStatusView.backgroundColor = UIColor(rgb: 0xF9EBEB)
            }
        case 2:
            DispatchQueue.main.async {
                cell.statusImage.image = UIImage(named: "icon_starGreen")
                cell.statusLabel.text = "Joined"
                cell.backgroundStatusView.backgroundColor = UIColor(rgb: 0xE5F9F4)
                cell.statusLabel.textColor = UIColor(rgb: 0x00C491)
            }
        default:
            DispatchQueue.main.async {
                cell.statusImage.image = UIImage(named: "icon_star")
                cell.statusLabel.text = "Tham gia"
                cell.backgroundStatusView.backgroundColor = UIColor.systemGray6
                cell.statusLabel.textColor = UIColor.systemGray
            }
        }
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == popularResponse.count - 2 && isLoadmore == true {
            self.alertLoading.createAlertLoading(target: self, isShowLoading: true)
            self.getListPopularData(isLoadMore: true, page: self.currentPage + 1 )
            self.currentPage += 1
        } else {
            dismiss(animated: true, completion: nil)
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
