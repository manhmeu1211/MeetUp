//
//  MyPageGoingViewController.swift
//  Training
//
//  Created by ManhLD on 12/20/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class MyPageGoingViewController: DataService {
    


    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var noEvents: UILabel!
    @IBOutlet weak var goingTable: UITableView!
    private let refreshControl = UIRefreshControl()
    
    
    var alertLoading = UIAlertController()
    let status = 1
    var goingEvents : [MyPageGoingResDatabase] = []
    let userToken = UserDefaults.standard.string(forKey: "userToken")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getListGoingEvent()
    }

    private func checkEvent() {
        if goingEvents == [] {
            noEvents.isHidden = false
        } else {
            noEvents.isHidden = true
        }
    }
    
    private func setupView() {
        loading.handleLoading(isLoading: true)
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
    
    private func updateObject() {
        let list = RealmDataBaseQuery.getInstance.getObjects(type: MyPageGoingResDatabase.self)!.toArray(ofType: MyPageGoingResDatabase.self)
        goingEvents = list
    }
       
       

    
    private func handleLogOut() {
        isLoginVC = true
        UserDefaults.standard.removeObject(forKey: "userToken")
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    
    private func getListGoingEvent() {
       let usertoken = UserDefaults.standard.string(forKey: "userToken")
       if usertoken == nil {
           ToastView.shared.short(self.view, txt_msg: "Not need to login first !")
       } else {
           let headers = [ "Authorization": "Bearer \(usertoken!)",
                           "Content-Type": "application/json"  ]
         
        getMyEventGoing(status: self.status, headers: headers) { (events, errCode) in
                if errCode == 1 {
                    ToastView.shared.short(self.view, txt_msg: "Cannot load data from server!")
                } else if errCode == 2 {
                    self.goingEvents.removeAll()
                    self.goingEvents = events
                    self.goingTable.reloadData()
                    self.checkEvent()
                }  else {
                    self.updateObject()
                    self.goingTable.reloadData()
                    ToastView.shared.short(self.view, txt_msg: "Check your connetion !")
                }
             self.loading.handleLoading(isLoading: false)
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
        cell.backgroundStatusView.isHidden = true
        cell.statusLabel.isHidden = true
        cell.statusImage.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let vc = EventDetailController(nibName: "EventDetailView", bundle: nil)
        vc.id = goingEvents[indexPath.row + 1].id
        present(vc, animated: true, completion: nil)
    }
    
}
