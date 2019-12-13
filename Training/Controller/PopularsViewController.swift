//
//  PopularsViewController.swift
//  Training
//
//  Created by ManhLD on 12/11/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class PopularsViewController: UIViewController {

    @IBOutlet weak var popularsTable: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()

    var popularResponse : [PopularsResDatabase] = []
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateObject()
        loading.isHidden = true
        setUpTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPopularData(isLoadMore: false, page: currentPage)
    }
    
    func setUpTable() {
        popularsTable.dataSource = self
        popularsTable.delegate = self
        popularsTable.rowHeight = UITableView.automaticDimension
        popularsTable.register(UINib(nibName: "PopularsTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularsTableViewCell")
        if #available(iOS 10.0, *) {
                   self.popularsTable.refreshControl = refreshControl
               } else {
                   self.popularsTable.addSubview(refreshControl)
               }
               self.refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
       }
    
    
    @objc func updateData() {
        getPopularData(isLoadMore: false, page: currentPage)
        self.refreshControl.endRefreshing()
    }
    
    
    func updateObject() {
        self.popularResponse = RealmDataBaseQuery.getInstance.getObjects(type: PopularsResDatabase.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: PopularsResDatabase.self)
    }
    
    
    func deleteObject() {
        for i in self.popularResponse {
            RealmDataBaseQuery.getInstance.deleteData(object: i)
        }
    }

    
    func getPopularData(isLoadMore : Bool, page : Int) {
        let queue = DispatchQueue(label: "appendPopularData")
            queue.async {
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
                        self.popularResponse = (RealmDataBaseQuery.getInstance.getObjects(type: PopularsResDatabase.self)?.toArray(ofType: PopularsResDatabase.self))!
                    } else {
                        _ = result.array?.forEach({ (populars) in
                            let populars = PopularsResDatabase(id: populars["id"].intValue, photo: populars["photo"].stringValue, name: populars["name"].stringValue, descriptionHtml: populars["description_html"].stringValue, scheduleStartDate: populars["schedule_start_date"].stringValue, scheduleEndDate: populars["schedule_end_date"].stringValue, scheduleStartTime: populars["schedule_start_time"].stringValue, scheduleEndTime: populars["schedule_end_time"].stringValue, schedulePermanent: populars["schedule_permanent"].stringValue, goingCount: populars["going_count"].intValue)
                                RealmDataBaseQuery.getInstance.addData(object: populars)
                        })
                        self.updateObject()
                    }
                    self.popularsTable.reloadData()
                    } else {
                        ToastView.shared.short(self.view, txt_msg: "Failed to load data from server")
                        print("Failed to load Data")
                }
            }
        }
    }
}



extension PopularsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "PopularsTableViewCell", for: indexPath) as! PopularsTableViewCell
     
        DispatchQueue.main.async {
            cell.imgPopulars.image = UIImage(data: self.popularResponse[indexPath.row].photo)
        }
        
        cell.eventsName.text = popularResponse[indexPath.row].name
        cell.desHTML.text = popularResponse[indexPath.row].descriptionHtml.replacingOccurrences(of: "[|<>/]", with: "", options: [.regularExpression])
        
        if popularResponse[indexPath.row].goingCount == 0 {
            cell.dateAndCount.text = "\(popularResponse[indexPath.row].scheduleStartDate) "
        } else {
             cell.dateAndCount.text = "\(popularResponse[indexPath.row].scheduleStartDate) - \(popularResponse[indexPath.row].goingCount) people going"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
      }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == popularResponse.count - 2 {
            self.getPopularData(isLoadMore: true, page: self.currentPage + 1 )
            self.currentPage += 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = popularResponse[indexPath.row].name
        print(name)
    }
    
}
