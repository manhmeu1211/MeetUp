//
//  SplashScreen.swift
//  Training
//
//  Created by ManhLD on 12/16/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class SplashScreen: UIViewController {
    
    @IBOutlet weak var progressing: UIProgressView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    let progress = Progress(totalUnitCount: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLoading()
        setUpNavBar()
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setUpLoading() {
        if (isFirtsLaunched == true) {
            print("getData")
            self.setUpDataNews()
            self.setUpDataPopulars()
            self.setUpCategories()
        } else {
            print("Do nothing")
        }
        progressing.progress = 0.0
        progress.completedUnitCount = 6
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            guard self.progress.isFinished == false else {
                timer.invalidate()
                return
            }
            self.progress.completedUnitCount += 1
            self.progressing.setProgress(Float(self.progress.fractionCompleted), animated: true)
            self.progressLabel.text = "Loading - \(Int(self.progress.fractionCompleted * 100)) %"
            if self.progress.completedUnitCount == 10 {
                self.setRootTabbar()
            }
        }
    }
    
    func setRootTabbar() {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
                 UIApplication.shared.windows.first?.rootViewController = vc
                 UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func setUpDataNews() {
        let queue = DispatchQueue(label: "insertDB")
        queue.async {
            getDataService.getInstance.getListNews(pageIndex: 1, pageSize: 10) { (data, errcode) in
                if errcode == 1 {
                    let result = data!
                    _ = result.array?.forEach({ (news) in
                        let news = NewsDataResponse(id: news["id"].intValue, feed:news["feed"].stringValue, title: news["title"].stringValue, thumbImg: news["thumb_img"].stringValue, author: news["author"].stringValue, publishdate: news["publish_date"].stringValue, url: news["detail_url"].stringValue)
                            RealmDataBaseQuery.getInstance.addData(object: news)
                    })
                }
            }
        }
    }
    
    func setUpDataPopulars() {
        let queue = DispatchQueue(label: "insertDBPL")
        queue.async {
            getDataService.getInstance.getListPopular(pageIndex: 1, pageSize: 10) { (data, errcode) in
                if errcode == 1 {
                     let result = data!
                    _ = result.array?.forEach({ (populars) in
                        let populars = PopularsResDatabase(id: populars["id"].intValue, photo: populars["photo"].stringValue, name: populars["name"].stringValue, descriptionHtml: populars["description_html"].stringValue, scheduleStartDate: populars["schedule_start_date"].stringValue, scheduleEndDate: populars["schedule_end_date"].stringValue, scheduleStartTime: populars["schedule_start_time"].stringValue, scheduleEndTime: populars["schedule_end_time"].stringValue, schedulePermanent: populars["schedule_permanent"].stringValue, goingCount: populars["going_count"].intValue)
                            RealmDataBaseQuery.getInstance.addData(object: populars)
                    })
                }
            }
        }
    }
    
    func setUpCategories() {
         let queue = DispatchQueue(label: "loadCate")
         queue.async {
             getDataService.getInstance.getListCategories { (json, errcode) in
                 if errcode == 1 {
                     let data = json!
                     _ = data.array?.forEach({ (cate) in
                         let categories = CategoriesResDatabase(id: cate["id"].intValue, name: cate["name"].stringValue, slug: cate["slug"].stringValue, parentId: cate["parent_id"].intValue)
                     RealmDataBaseQuery.getInstance.addData(object: categories)
                     })
                 } else {
                     ToastView.shared.short(self.view, txt_msg: "Failed to load data from server")
                 }
             }
         }
     }
}
