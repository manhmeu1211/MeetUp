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
        eventTable.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
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
        eventTable.reloadData()
        self.titleCategories.text = "\(self.headerTitle!)(\(self.eventsByCate.count))"
    }
    
    private func updateObjectByDate() {
        self.eventsByCate = RealmDataBaseQuery.getInstance.getObjects(type: EventsByCategoriesDatabase.self)!.sorted(byKeyPath: "scheduleStartDate", ascending: false).toArray(ofType: EventsByCategoriesDatabase.self)
        checkEvent()
        eventTable.reloadData()
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
        let userToken = UserDefaults.standard.string(forKey: "userToken")
        let headers = [ "Authorization": "Bearer " + userToken!,
                    "Content-Type": "application/json"  ]
        getDataService.getInstance.getListEventsByCategories(id: categoriesID, pageIndex: page, headers: headers, isLoadMore: isLoadMore) { (eventsCate, errcode) in
            if errcode == 1 {
                self.loading.handleLoading(isLoading: false)
                self.updateObjectByPopulars()
            } else if errcode == 2 {
                if isLoadMore == false {
                    self.eventsByCate.removeAll()
                    self.eventsByCate = eventsCate
                } else {
                    self.eventsByCate = eventsCate
                }
                self.eventTable.reloadData()
                self.loading.handleLoading(isLoading: false)
            } else {
                self.updateObjectByPopulars()
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
        navigationController?.popViewController(animated: true)
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
        let cell = eventTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let queue = DispatchQueue(label: "loadImageEventByCate")
        queue.async {
            DispatchQueue.main.async {
                cell.imgTimer.image = UIImage(named: "Group15")
                cell.imgNews.image = UIImage(data: self.eventsByCate[indexPath.row].photo)
            }
        }
        cell.date.textColor = UIColor(rgb: 0x5D20CD)
        cell.date.text = "\(eventsByCate[indexPath.row].scheduleStartDate) - \(eventsByCate[indexPath.row].goingCount) people going"
        cell.title.text = eventsByCate[indexPath.row].name
        cell.lblDes.text = eventsByCate[indexPath.row].descriptionHtml
        cell.backgroundStatusView.isHidden = true
        cell.statusImage.isHidden = true
        cell.statusLabel.isHidden = true
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
