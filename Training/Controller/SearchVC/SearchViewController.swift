//
//  SearchViewController.swift
//  Training
//
//  Created by ManhLD on 12/12/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var searchTable: UITableView!
    
    @IBOutlet weak var viewBtn: UIView!
 
    @IBOutlet weak var incaditorView: UIView!
    
    
    @IBOutlet weak var incaditorLeading: NSLayoutConstraint!
    
    @IBOutlet weak var noResults: UILabel!
    
    
    private let refreshControl = UIRefreshControl()
     
    var currentPage = 1
    var currentClick = false
    var pastClick = false
    var searchResponse : [SearchResponseDatabase] = []
    let realm = try! Realm()
    var alertLoading = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVỉew()
    }
    
    func setUpVỉew() {
        self.tabBarController?.tabBar.isHidden = true
        noResults.isHidden = true
        txtSearch.delegate = self
        searchTable.dataSource = self
        searchTable.delegate = self
        searchTable.rowHeight = UITableView.automaticDimension
        searchTable.register(UINib(nibName: "PopularsTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularsTableViewCell")
        if #available(iOS 10.0, *) {
            self.searchTable.refreshControl = refreshControl
        } else {
            self.searchTable.addSubview(refreshControl)
        }
            self.refreshControl.addTarget(self, action: #selector(updateDataSeacrch), for: .valueChanged)
        
    }
    
    func updateObject() {
          self.searchResponse = RealmDataBaseQuery.getInstance.getObjects(type: SearchResponseDatabase.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: SearchResponseDatabase.self)
      }
      
    func deleteObject() {
        let list = realm.objects(SearchResponseDatabase.self).toArray(ofType: SearchResponseDatabase.self)
        try! realm.write {
            realm.delete(list)
        }
    }
    
    func handleSearch(isLoadMore : Bool, page : Int) {
        let keyword = txtSearch.text!
        let usertoken = UserDefaults.standard.string(forKey: "userToken")
        if usertoken == nil {
            ToastView.shared.short(self.view, txt_msg: "Not need to login first !")
        } else {
            let headers = [ "token": usertoken!,
                                "Content-Type": "application/json"  ]
            getDataService.getInstance.search(pageIndex: page, pageSize: 10, keyword: keyword, header: headers) { (json, errcode) in
                if errcode == 1 {
                    ToastView.shared.short(self.view, txt_msg: "Cannot search data from sever !")
                    self.alertLoading.createAlertLoading(target: self, isShowLoading: true)
                } else if errcode == 2 {
                    let data = json!
                    if isLoadMore == false {
                        self.deleteObject()
                        self.searchResponse.removeAll()
                        _ = data.array?.forEach({ (search) in
                        let searchRes = SearchResponseDatabase(id: search["id"].intValue, photo: search["photo"].stringValue, name: search["name"].stringValue, descriptionHtml: search["description_html"].stringValue, scheduleStartDate: search["schedule_start_date"].stringValue, scheduleEndDate: search["schedule_end_date"].stringValue, scheduleStartTime: search["schedule_start_time"].stringValue, scheduleEndTime: search["schedule_end_time"].stringValue, schedulePermanent: search["schedule_permanent"].stringValue, goingCount: search["going_count"].intValue)
                                RealmDataBaseQuery.getInstance.addData(object: searchRes)
                        })
                    } else {
                        _ = data.array?.forEach({ (search) in
                        let searchRes = SearchResponseDatabase(id: search["id"].intValue, photo: search["photo"].stringValue, name: search["name"].stringValue, descriptionHtml: search["description_html"].stringValue, scheduleStartDate: search["schedule_start_date"].stringValue, scheduleEndDate: search["schedule_end_date"].stringValue, scheduleStartTime: search["schedule_start_time"].stringValue, scheduleEndTime: search["schedule_end_time"].stringValue, schedulePermanent: search["schedule_permanent"].stringValue, goingCount: search["going_count"].intValue)
                        RealmDataBaseQuery.getInstance.addData(object: searchRes)
                        })
                    }
                    self.updateObject()
                    self.searchTable.reloadData()
                    if self.searchResponse.isEmpty {
                        self.noResults.isHidden = false
                    } else {
                        self.noResults.isHidden = true
                    }
                    self.alertLoading.createAlertLoading(target: self, isShowLoading: false)
                } else {
                    self.alertLoading.createAlertLoading(target: self, isShowLoading: false)
                    ToastView.shared.short(self.view, txt_msg: "Failed to load data, check your connection!")
                    self.noResults.text = "Failed to load data from sever"
                    self.noResults.isHidden = false
                }
            }
        }
    }
    
    @objc func updateDataSeacrch() {
        handleSearch(isLoadMore: false, page: currentPage)
        refreshControl.endRefreshing()
    }
     
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
 
    @IBAction func backBtn(_ sender: Any) {
        isSearchVC = true
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
 
    @IBAction func clearText(_ sender: Any) {
        txtSearch.text = ""
    }
    
    
    @IBAction func incomingBtn(_ sender: Any) {
        incaditorLeading.constant = 0
    }
    
    
    @IBAction func pastBtn(_ sender: Any) {
        incaditorLeading.constant = viewBtn.frame.width/2
    }
}

extension SearchViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        alertLoading.createAlertLoading(target: self, isShowLoading: true)
        view.endEditing(true)
         handleSearch(isLoadMore: false, page: currentPage)
         return true
     }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: "PopularsTableViewCell", for: indexPath) as! PopularsTableViewCell
        let queue = DispatchQueue(label: "loadImageSearch")
        queue.async {
            DispatchQueue.main.async {
                cell.imgPopulars.image = UIImage(data: self.searchResponse[indexPath.row].photo)
            }
        }
        cell.eventsName.text = searchResponse[indexPath.row].name
        cell.desHTML.text = searchResponse[indexPath.row].descriptionHtml.replacingOccurrences(of: "[|<>/]", with: "", options: [.regularExpression])
               
        if searchResponse[indexPath.row].goingCount == 0 {
            cell.dateAndCount.text = "\(searchResponse[indexPath.row].scheduleStartDate) "
        } else {
            cell.dateAndCount.text = "\(searchResponse[indexPath.row].scheduleStartDate) - \(searchResponse[indexPath.row].goingCount) people going"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
      
      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          if indexPath.row == searchResponse.count - 2 {
            self.handleSearch(isLoadMore: true, page: self.currentPage + 1)
            self.currentPage += 1
            self.noResults.isHidden = true
          }
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let name = searchResponse[indexPath.row].name
          print(name)
      }
    
}
