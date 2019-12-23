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
    
    
    @IBOutlet weak var titleCategories: UILabel!
    
    @IBOutlet weak var incaditorLeading: NSLayoutConstraint!
    
    
    @IBOutlet weak var incaditorView: UIView!
    
    @IBOutlet weak var eventTable: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var id : Int?
    var headerTitle : String?
    
    var currentPage = 1
    
    var eventsByCate : [EventsByCategoriesDatabase] = []
    
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVỉew()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let token = UserDefaults.standard.string(forKey: "userToken")
        if token != nil {
//            loadingHubShow()
            deleteObject()
            eventsByCate.removeAll()
            getDataEventsByCategories(isLoadMore: false, page: currentPage)
        } else {
            print("Token is null")
            ToastView.shared.long(self.view, txt_msg: "Not logged in")
        }
    }
    

    func setupVỉew() {
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
      
    
    func loadingHubShow() {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }

    func loadingHubDismiss() {
        alert.dismiss(animated: true, completion: nil)
    }
  
    
    func updateObjectByPopulars() {
        self.eventsByCate = RealmDataBaseQuery.getInstance.getObjects(type: EventsByCategoriesDatabase.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: EventsByCategoriesDatabase.self)
         self.titleCategories.text = "\(self.headerTitle!)(\(self.eventsByCate.count))"
    }
    
    func updateObjectByDate() {
        self.eventsByCate = RealmDataBaseQuery.getInstance.getObjects(type: EventsByCategoriesDatabase.self)!.sorted(byKeyPath: "scheduleStartDate", ascending: false).toArray(ofType: EventsByCategoriesDatabase.self)
         self.titleCategories.text = "\(self.headerTitle!)(\(self.eventsByCate.count))"
    }
    
        
    func deleteObject() {
        let list = realm.objects(EventsByCategoriesDatabase.self).toArray(ofType: EventsByCategoriesDatabase.self)
        try! realm.write {
            realm.delete(list)
        }
    }



    func getDataEventsByCategories(isLoadMore : Bool, page: Int) {
        print("getData")
        let categoriesID = id!
        let usertoken = UserDefaults.standard.string(forKey: "userToken")
        let headers = [ "token": usertoken!,
                        "Content-Type": "application/json" ]
        
        let queue = DispatchQueue(label: "eventsByCate")
        queue.async {
            getDataService.getInstance.getListEventsByCategories(id: categoriesID, pageIndex: page, headers: headers) { (json, errcode) in
                if errcode == 1 {
                    self.loadingHubDismiss()
                } else if errcode == 2 {
                    let data = json!
                    if isLoadMore == false {
                        self.deleteObject()
                        self.eventsByCate.removeAll()
                        _ = data.array?.forEach({ (event) in
                        let eventsRes = EventsByCategoriesDatabase(id: event["id"].intValue, photo: event["photo"].stringValue, name: event["name"].stringValue, descriptionHtml: event["description_html"].stringValue, scheduleStartDate: event["schedule_start_date"].stringValue, scheduleEndDate: event["schedule_end_date"].stringValue, scheduleStartTime: event["schedule_start_time"].stringValue, scheduleEndTime: event["schedule_end_time"].stringValue, schedulePermanent: event["schedule_permanent"].stringValue, goingCount: event["going_count"].intValue)
                        RealmDataBaseQuery.getInstance.addData(object: eventsRes)
                        })
                    } else {
                        _ = data.array?.forEach({ (event) in
                        let eventsRes = EventsByCategoriesDatabase(id: event["id"].intValue, photo: event["photo"].stringValue, name: event["name"].stringValue, descriptionHtml: event["description_html"].stringValue, scheduleStartDate: event["schedule_start_date"].stringValue, scheduleEndDate: event["schedule_end_date"].stringValue, scheduleStartTime: event["schedule_start_time"].stringValue, scheduleEndTime: event["schedule_end_time"].stringValue, schedulePermanent: event["schedule_permanent"].stringValue, goingCount: event["going_count"].intValue)
                        RealmDataBaseQuery.getInstance.addData(object: eventsRes)
                        })
                    }
                    self.updateObjectByPopulars()
                    self.eventTable.reloadData()
                    self.loadingHubDismiss()
                    print(self.eventsByCate.count)
                } else {
                    self.updateObjectByPopulars()
                    self.loadingHubDismiss()
                    ToastView.shared.short(self.view, txt_msg: "Failed to load data, check your connection!")
                }
            }
        }
    }
    
    
    
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


extension EventsByCategoriesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsByCate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTable.dequeueReusableCell(withIdentifier: "PopularsTableViewCell", for: indexPath) as! PopularsTableViewCell
        
        DispatchQueue.main.async {
            cell.imgPopulars.image = UIImage(data: self.eventsByCate[indexPath.row].photo)
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
