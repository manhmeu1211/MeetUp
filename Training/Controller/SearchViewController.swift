//
//  SearchViewController.swift
//  Training
//
//  Created by ManhLD on 12/12/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    var searchResponse : [SearchResponseDatabase] = []

    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var searchTable: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var currentPage = 1
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        handleLoading(isLoading: false, loading: loading)
        setUpTable()
    }
    
    func setUpTable() {
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
            self.refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
    }
    
    
    func updateObject() {
          self.searchResponse = RealmDataBaseQuery.getInstance.getObjects(type: SearchResponseDatabase.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: SearchResponseDatabase.self)
      }
      
      
      func deleteObject() {
          for i in self.searchResponse {
              RealmDataBaseQuery.getInstance.deleteData(object: i)
          }
      }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
     func handleSearch(isLoadMore : Bool, page : Int) {
        let keyword = txtSearch.text!
        let usertoken = token
        if usertoken == nil {
            ToastView.shared.short(self.view, txt_msg: "Not logged in")
        } else {
            let headers = [
                               "token": token!,
                               "Content-Type": "application/json"
                            ]
            let queue = DispatchQueue(label: "searchData")
            queue.async {
                getDataService.getInstance.search(pageIndex: page, pageSize: 10, keyword: keyword, header: headers) { (json, errcode) in
                    if errcode == 1 {
                        
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
                        handleLoading(isLoading: false, loading: self.loading)
                    } else {
                        ToastView.shared.short(self.view, txt_msg: "Failed to load data, check your connection!")
                    }
            }
        }
    }
}
    
    @objc func updateData() {
        handleSearch(isLoadMore: false, page: currentPage)
        refreshControl.endRefreshing()
    }
     
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        handleLoading(isLoading: true, loading: loading)
        handleSearch(isLoadMore: false, page: currentPage)
        return true
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
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: "PopularsTableViewCell", for: indexPath) as! PopularsTableViewCell
        DispatchQueue.main.async {
            cell.imgPopulars.image = UIImage(data: self.searchResponse[indexPath.row].photo)
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
              self.handleSearch(isLoadMore: true, page: self.currentPage + 1 )
              self.currentPage += 1
          }
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let name = searchResponse[indexPath.row].name
          print(name)
      }
    
}
