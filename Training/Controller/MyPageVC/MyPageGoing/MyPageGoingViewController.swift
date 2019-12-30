//
//  MyPageGoingViewController.swift
//  Training
//
//  Created by ManhLD on 12/20/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class MyPageGoingViewController: UIViewController {
    


    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var noEvents: UILabel!
    @IBOutlet weak var goingTable: UITableView!
    private let refreshControl = UIRefreshControl()
    
    
    private var alertLoading = UIAlertController()
    private let status = 1
    private var goingEvents : [MyPageGoingResDatabase] = []
    private var goingEventsEnd : [MyPageGoingResDatabase] = []
    private let userToken = UserDefaults.standard.string(forKey: "userToken")
    private let today = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getListGoingEvent()
    }

    private func checkEvent() {
        if goingEvents == [] && goingEventsEnd == [] {
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

    }
    
    private func updateObject() {
        let list = RealmDataBaseQuery.getInstance.getObjects(type: MyPageGoingResDatabase.self)!.toArray(ofType: MyPageGoingResDatabase.self)
        goingEvents = list
    }
       
    
    private func handleLogOut() {
        navigationController?.popToRootViewController(animated: true)
    }

    
    private func getListGoingEvent() {
       let usertoken = UserDefaults.standard.string(forKey: "userToken")
       if usertoken == nil {
           ToastView.shared.short(self.view, txt_msg: "Not need to login first !")
       } else {
           let headers = [ "Authorization": "Bearer \(usertoken!)",
                           "Content-Type": "application/json"  ]
         
        getDataService.getInstance.getMyEventGoing(status: self.status, headers: headers) { (events, errCode) in
                if errCode == 1 {
                    ToastView.shared.short(self.view, txt_msg: "Cannot load data from server!")
                } else if errCode == 2 {
                    self.goingEvents.removeAll()
                    let dateFormatter = Date()
                    for i in events {
                         let date = dateFormatter.converStringToDate(formatter: Date.StyleDate.dateOnly, dateString: i.scheduleStartDate)
                         if date! < self.today {
                            self.goingEventsEnd.append(i)
                         } else {
                            self.goingEvents.append(i)
                        }
                     }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return goingEvents.count
        default:
            return goingEventsEnd.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if goingEvents.count == 0 {
                return ""
            }
            return "Events is going"
        default:
            if goingEventsEnd.count == 0 {
                return ""
            }
            return "Events end"
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = goingTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            let queue = DispatchQueue(label: "loadImageGoing")
            queue.async {
                DispatchQueue.main.async {
                    cell.statusImage.image = UIImage(named: "icon_starRed")
                    cell.statusLabel.text = "Can participate"
                    cell.statusLabel.textColor = UIColor(rgb: 0xC63636)
                    cell.backgroundStatusView.backgroundColor = UIColor(rgb: 0xF9EBEB)
                    cell.imgTimer.image = UIImage(named: "Group15")
                    cell.date.textColor = UIColor(rgb: 0x5D20CD)
                    cell.imgNews.image = UIImage(data: self.goingEvents[indexPath.row].photo)
                }
            }
            cell.date.text = "\(goingEvents[indexPath.row].scheduleStartDate) - \(goingEvents[indexPath.row].goingCount) people going"
            cell.title.text = goingEvents[indexPath.row].name
            cell.lblDes.text = goingEvents[indexPath.row].descriptionHtml
            return cell
        default:
            let cell = goingTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            let queue = DispatchQueue(label: "loadImageGoing")
            queue.async {
                DispatchQueue.main.async {
                    cell.statusImage.image = UIImage(named: "icon_starRed")
                    cell.statusLabel.text = "Can participate"
                    cell.statusLabel.textColor = UIColor(rgb: 0xC63636)
                    cell.backgroundStatusView.backgroundColor = UIColor(rgb: 0xF9EBEB)
                    cell.imgTimer.image = UIImage(named: "Group15")
                    cell.date.textColor = UIColor(rgb: 0x5D20CD)
                    cell.imgNews.image = UIImage(data: self.goingEventsEnd[indexPath.row].photo)
                }
            }
            cell.date.text = "\(goingEventsEnd[indexPath.row].scheduleStartDate) - \(goingEventsEnd[indexPath.row].goingCount) people going"
            cell.title.text = goingEventsEnd[indexPath.row].name
            cell.lblDes.text = goingEventsEnd[indexPath.row].descriptionHtml
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let vc = EventDetailController(nibName: "EventDetailView", bundle: nil)
        switch indexPath.section {
        case 0:
            vc.id = goingEvents[indexPath.row].id
        default:
            vc.id = goingEventsEnd[indexPath.row].id
        }
        present(vc, animated: true, completion: nil)
    }
    
}
