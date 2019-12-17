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

 
    @IBOutlet weak var newsTable: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var currentPage = 1
    
    var timeToLoading : Timer?
    
    private let refreshControl = UIRefreshControl()
    
    var newsResponse : [NewsDataResponse] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateObject()
        setUpTable()
        loading.isHidden = true
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
        for i in self.newsResponse {
            RealmDataBaseQuery.getInstance.deleteData(object: i)
        }
    }
    
    func updateObject() {
        self.newsResponse = RealmDataBaseQuery.getInstance.getObjects(type: NewsDataResponse.self)!.sorted(byKeyPath: "publishdate", ascending: false).toArray(ofType: NewsDataResponse.self)
    }

    func getNewsData(shoudLoadmore: Bool, page: Int) {
        loading.stopAnimating()
        loading.isHidden = true
        let queue = DispatchQueue(label: "appendData")
            queue.async {
                getDataService.getInstance.getListNews(pageIndex: page, pageSize: 10) { (data, isSuccess) in
                    if isSuccess == 1 {
                        let result = data!
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
                        self.newsTable.reloadData()
                    } else {
                        self.updateObject()
                        print("Failed to load Data")
                        ToastView.shared.short(self.view, txt_msg: "Failed to load data from server")
                   }
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
        DispatchQueue.main.async {
            cell.imgNews.image = UIImage(data: self.newsResponse[indexPath.row].thumbImg)
        }
        cell.lblDes.text = "By \(newsResponse[indexPath.row].author) - From \(newsResponse[indexPath.row].feed)"
        cell.title.text = newsResponse[indexPath.row].title
        cell.date.text = "\(newsResponse[indexPath.row].publishdate)"
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == newsResponse.count - 2 {
            handleLoading(isLoading: true, loading: loading)
            self.getNewsData(shoudLoadmore: true, page: self.currentPage + 1)
            self.currentPage += 1
        }
       
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let url = URL(string: newsResponse[indexPath.row + 1].url) else { return }
        print(url)
        UIApplication.shared.open(url)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
