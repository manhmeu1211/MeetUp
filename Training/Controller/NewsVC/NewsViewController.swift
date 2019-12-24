//
//  NewsViewController.swift
//  Training
//
//  Created by ManhLD on 12/11/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class NewsViewController: UIViewController {
    
    let realm = try! Realm()
 
    @IBOutlet weak var newsTable: UITableView!
    
    var alertLoading = UIAlertController()
    var currentPage = 1
    var newsResponse : [NewsDataResponse] = []
    let dateformatted = DateFormatter()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        if detechDailyFirstLaunch() == false {
            updateObject()
            alertLoading.createAlertLoading(target: self, isShowLoading: false)
        } else {
            alertLoading.createAlertLoading(target: self, isShowLoading: true)
            getNewsData(shoudLoadmore: false, page: currentPage)
        }
    }
    
  
    func detechDailyFirstLaunch() -> Bool {
         let today = NSDate().formatted
         if (UserDefaults.standard.string(forKey: "FIRSTLAUNCHNEWS") == today) {
             print("already launched")
             return false
         } else {
             print("first launch")
             UserDefaults.standard.setValue(today, forKey:"FIRSTLAUNCHNEWS")
             return true
         }
     }
    
    func setUpTable() {
        newsTable.dataSource = self
        newsTable.delegate = self
        newsTable.rowHeight = UITableView.automaticDimension
        newsTable.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        if #available(iOS 10.0, *) {
            self.newsTable.refreshControl = refreshControl
        } else {
            self.newsTable.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
    }
    
    @objc func updateData() {
        getNewsData(shoudLoadmore: false, page: currentPage)
        self.refreshControl.endRefreshing()
    }
    
       
    func deleteObject() {
        let list = realm.objects(NewsDataResponse.self).toArray(ofType: NewsDataResponse.self)
        try! realm.write {
            realm.delete(list)
        }
    }
    
    func updateObject() {
        let list = RealmDataBaseQuery.getInstance.getObjects(type: NewsDataResponse.self)!.toArray(ofType: NewsDataResponse.self)
        newsResponse = list
        newsTable.reloadData()
    }

    func getNewsData(shoudLoadmore: Bool, page: Int) {
        getDataService.getInstance.getListNews(pageIndex: page, pageSize: 10) { (json, errCode) in
            if errCode == 1 {
                let result = json!
                if shoudLoadmore == false {
                    self.deleteObject()
                    self.newsResponse.removeAll()
                    _ = result.array?.forEach({ (news) in
                        let news = NewsDataResponse(id: news["id"].intValue, feed:news["feed"].stringValue, title: news["title"].stringValue, thumbImg: news["thumb_img"].stringValue, author: news["author"].stringValue, publishdate: news["publish_date"].stringValue, url: news["detail_url"].stringValue)
                        RealmDataBaseQuery.getInstance.addData(object: news)
                    })
                } else {
                    _ = result.array?.forEach({ (news) in
                    let news = NewsDataResponse(id: news["id"].intValue, feed: news["feed"].stringValue, title: news["title"].stringValue, thumbImg: news["thumb_img"].stringValue, author: news["author"].stringValue, publishdate: news["publish_date"].stringValue, url: news["detail_url"].stringValue)
                        RealmDataBaseQuery.getInstance.addData(object: news)
                    })
                }
                self.updateObject()
                self.alertLoading.createAlertLoading(target: self, isShowLoading: false)
            } else {
                self.updateObject()
                self.alertLoading.createAlertLoading(target: self, isShowLoading: false)
                print("Failed to load Data")
                ToastView.shared.short(self.view, txt_msg: "Failed to load data from server")
            }
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsResponse.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let queue = DispatchQueue(label: "loadImageNews")
        queue.async {
             DispatchQueue.main.async {
                cell.imgNews.image = UIImage(data: self.newsResponse[indexPath.row].thumbImg)
            }
        }
        cell.lblDes.text = "By \(newsResponse[indexPath.row].author) - From \(newsResponse[indexPath.row].feed)"
        cell.title.text = newsResponse[indexPath.row].title
        cell.date.text = "\(newsResponse[indexPath.row].publishdate)"
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == newsResponse.count - 2 {
            alertLoading.createAlertLoading(target: self, isShowLoading: true)
            currentPage += 1
            self.getNewsData(shoudLoadmore: true, page: currentPage)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let url = newsResponse[indexPath.row + 1].url
        let vc = WebViewController()
        vc.urlToOpen = url
        present(vc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
