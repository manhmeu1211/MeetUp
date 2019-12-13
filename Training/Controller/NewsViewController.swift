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

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var currentPage = 1
    
    var timeToLoading : Timer?
    
    private let refreshControl = UIRefreshControl()
    
    var newsResponse : [NewsResDataBase] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        loading.isHidden = true
        getNewsData(shoudLoadmore: false, page: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateObject()
    }

    func setUpTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
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
         self.newsResponse = RealmDataBaseQuery.getInstance.getObjects(type: NewsResDataBase.self)!.sorted(byKeyPath: "publishdate", ascending: false).toArray(ofType: NewsResDataBase.self)
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
                                let news = NewsResDataBase(id: news["id"].intValue, feed:news["feed"].stringValue, title: news["title"].stringValue, thumbImg: news["thumb_img"].stringValue, author: news["author"].stringValue, publishdate: news["publish_date"].stringValue, url: news["detail_url"].stringValue)
                                RealmDataBaseQuery.getInstance.addData(object: news)
                            })
                            self.updateObject()
                            } else {
                                _ = result.array?.forEach({ (news) in
                                let news = NewsResDataBase(id: news["id"].intValue, feed: news["feed"].stringValue, title: news["title"].stringValue, thumbImg: news["thumb_img"].stringValue, author: news["author"].stringValue, publishdate: news["publish_date"].stringValue, url: news["detail_url"].stringValue)
                                RealmDataBaseQuery.getInstance.addData(object: news)
                                })
                            self.updateObject()
                            }
                        self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        DispatchQueue.main.async {
            cell.imgNews.image = UIImage(data: self.newsResponse[indexPath.row].thumbImg)
        }
        cell.title.text = newsResponse[indexPath.row].title
        cell.date.text = "\(newsResponse[indexPath.row].publishdate) by \(newsResponse[indexPath.row].author) on \(newsResponse[indexPath.row].feed)"
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == newsResponse.count - 2 {
            loading.isHidden = false
            loading.startAnimating()
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
