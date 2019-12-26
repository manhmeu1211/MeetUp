//
//  EventsByCategoriesViewController.swift
//  Training
//
//  Created by ManhLD on 12/19/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class EventsByCategoriesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var noResults: UILabel!
    @IBOutlet weak var titleCategories: UILabel!
    @IBOutlet weak var incaditorLeading: NSLayoutConstraint!
    @IBOutlet weak var incaditorView: UIView!
    @IBOutlet weak var eventTable: UITableView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Varribles
    
    var id : Int?
    var headerTitle : String?
    private var currentPage = 1
    private var eventsByCate : [EventsByCategoriesDatabase] = []
    private let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    private let realm = try! Realm()
    private let token = UserDefaults.standard.string(forKey: "userToken")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVỉew()
        loading.handleLoading(isLoading: true)
        getDataEventV2()
    }
    
    
    
    // MARK: - Function setup views and data
    
    private func getDataEventV2() {
        if token != nil {
            getDataEventsByCategories(isLoadMore: false, page: currentPage)
            noResults.isHidden = true
        } else {
            noResults.isHidden = false
            loading.handleLoading(isLoading: false)
            ToastView.shared.long(self.view, txt_msg: "Not logged in")
        }
    }
    

    private func setupVỉew() {
        noResults.isHidden = true
        eventTable.dataSource = self
        eventTable.delegate = self
        eventTable.rowHeight = UITableView.automaticDimension
        eventTable.register(UINib(nibName: "PopularsTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularsTableViewCell")
        titleCategories.text = "\(headerTitle!)(\(eventsByCate.count))"
        if #available(iOS 10.0, *) {
            self.eventTable.refreshControl = refreshControl
        } else {
            self.eventTable.addSubview(refreshControl)
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing data")
        refreshControl.addTarget(self, action: #selector(upDateData), for: .valueChanged)
    }
    
    
    @objc func upDateData() {
          getDataEventsByCategories(isLoadMore: false, page: currentPage)
          refreshControl.endRefreshing()
      }
  
    private func updateObjectByPopulars() {
        self.eventsByCate = RealmDataBaseQuery.getInstance.getObjects(type: EventsByCategoriesDatabase.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: EventsByCategoriesDatabase.self)
        checkEvent()
        self.titleCategories.text = "\(self.headerTitle!)(\(self.eventsByCate.count))"
    }
    
    private func updateObjectByDate() {
        self.eventsByCate = RealmDataBaseQuery.getInstance.getObjects(type: EventsByCategoriesDatabase.self)!.sorted(byKeyPath: "scheduleStartDate", ascending: false).toArray(ofType: EventsByCategoriesDatabase.self)
        checkEvent()
        self.titleCategories.text = "\(self.headerTitle!)(\(self.eventsByCate.count))"
    }
    
    private func checkEvent() {
        if eventsByCate == [] {
            noResults.isHidden = false
            noResults.text = "No events"
        } else {
            noResults.isHidden = true
        }
    }
    
        
    private func deleteObject() {
        let list = realm.objects(EventsByCategoriesDatabase.self).toArray(ofType: EventsByCategoriesDatabase.self)
        try! realm.write {
            realm.delete(list)
        }
    }

    func getDataEventsByCategories(isLoadMore : Bool, page: Int) {
        let categoriesID = id!
        let usertoken = UserDefaults.standard.string(forKey: "userToken")
        let headers = [ "token": usertoken!,
                        "Content-Type": "application/json" ]
        getDataService.getInstance.getListEventsByCategories(id: categoriesID, pageIndex: page, headers: headers) { (json, errcode) in
            if errcode == 1 {
                self.loading.handleLoading(isLoading: false)
                self.updateObjectByPopulars()
            } else if errcode == 2 {
                let data = json!
                if isLoadMore == false {
                    self.deleteObject()
                    self.eventsByCate.removeAll()
                    _ = data.array?.forEach({ (event) in
                    let eventsRes = EventsByCategoriesDatabase(event: event)
                    RealmDataBaseQuery.getInstance.addData(object: eventsRes)
                    })
                } else {
                    _ = data.array?.forEach({ (event) in
                    let eventsRes = EventsByCategoriesDatabase(event: event)
                    RealmDataBaseQuery.getInstance.addData(object: eventsRes)
                    })
                }
                self.updateObjectByPopulars()
                self.eventTable.reloadData()
                self.loading.handleLoading(isLoading: false)
            } else {
                self.updateObjectByPopulars()
                ToastView.shared.short(self.view, txt_msg: "Failed to load data, check your connection!")
                self.loading.handleLoading(isLoading: false)
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func byPopulars(_ sender: Any) {
        eventsByCate.removeAll()
        updateObjectByPopulars()
        eventTable.reloadData()
        incaditorLeading.constant = 0
    }
    
    
    @IBAction func byDate(_ sender: Any) {
        eventsByCate.removeAll()
        updateObjectByDate()
        eventTable.reloadData()
        incaditorLeading.constant = incaditorView.frame.width/2
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        isSearchVC = true
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func toSearchViewBtn(_ sender: Any) {
        let searchView = SearchViewController()
        navigationController?.pushViewController(searchView, animated: true)
    }
}


// MARK: - Extension tableview

extension EventsByCategoriesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsByCate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTable.dequeueReusableCell(withIdentifier: "PopularsTableViewCell", for: indexPath) as! PopularsTableViewCell
        let queue = DispatchQueue(label: "loadImageEventByCate")
        queue.async {
            DispatchQueue.main.async {
                cell.imgPopulars.image = UIImage(data: self.eventsByCate[indexPath.row].photo)
            }
        }
        cell.eventsName.text = eventsByCate[indexPath.row].name
        cell.desHTML.text = eventsByCate[indexPath.row].descriptionHtml.replacingOccurrences(of: "[|<>/]", with: "", options: [.regularExpression])
        
        if eventsByCate[indexPath.row].goingCount == 0 {
            cell.dateAndCount.text = "\(eventsByCate[indexPath.row].scheduleStartDate) "
        } else {
             cell.dateAndCount.text = "\(eventsByCate[indexPath.row].scheduleStartDate) - \(eventsByCate[indexPath.row].goingCount) people going"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           if indexPath.row == eventsByCate.count - 2 {
                self.getDataEventsByCategories(isLoadMore: true, page: self.currentPage + 1 )
                self.currentPage += 1
           }
       }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let name = eventsByCate[indexPath.row].name
           print(name)
    }
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
               return UITableView.automaticDimension
    }
}
