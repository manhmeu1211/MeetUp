//
//  BrowserViewController.swift
//  Training
//
//  Created by ManhLD on 12/11/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import RealmSwift

class BrowserViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoriesTable: UITableView!
    
     // MARK: - Varribles
    
    var alertLoading = UIAlertController()
    let refreshControl = UIRefreshControl()
    var cateList : [CategoriesResDatabase] = []
    let realm = try! Realm()
    let userToken = UserDefaults.standard.string(forKey: "userToken")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButton()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         if userToken == nil {
            alertLoading.createAlertLoading(target: self, isShowLoading: true)
            getListCategories()
        } else {
            updateObject()
        }
    }
    
     // MARK: - setup View
    
    func setUpBarButton() {
        self.title = "Categories"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(handleSearchViewController))
          self.tabBarController?.tabBar.isHidden = false
    }

  
    func setupTable() {
        categoriesTable.delegate = self
        categoriesTable.dataSource = self
        categoriesTable.register(UINib(nibName: "CategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesTableViewCell")
        if #available(iOS 10.0, *) {
                   self.categoriesTable.refreshControl = refreshControl
               } else {
                   self.categoriesTable.addSubview(refreshControl)
               }
               self.refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
    }
    
     // MARK: - getData
    
    @objc func updateData() {
        getListCategories()
        self.refreshControl.endRefreshing()
    }
    
    func updateObject() {
        let list = (RealmDataBaseQuery.getInstance.getObjects(type: CategoriesResDatabase.self)?.toArray(ofType: CategoriesResDatabase.self))!
        cateList = list
        alertLoading.createAlertLoading(target: self, isShowLoading: false)
    }
    
    
    func deleteObject() {
        let list = realm.objects(CategoriesResDatabase.self).toArray(ofType: CategoriesResDatabase.self)
        try! realm.write {
            realm.delete(list)
        }
    }
       
    
    func getListCategories() {
        getDataService.getInstance.getListCategories { (json, errcode) in
            if errcode == 1 {
                self.deleteObject()
                self.cateList.removeAll()
                let data = json!
                _ = data.array?.forEach({ (cate) in
                    let categories = CategoriesResDatabase(id: cate["id"].intValue, name: cate["name"].stringValue, slug: cate["slug"].stringValue, parentId: cate["parent_id"].intValue)
                RealmDataBaseQuery.getInstance.addData(object: categories)
                })
                self.updateObject()
                self.categoriesTable.reloadData()
            } else {
                self.updateObject()
                self.categoriesTable.reloadData()
                ToastView.shared.short(self.view, txt_msg: "Failed to load data from server")
            }
            self.alertLoading.createAlertLoading(target: self, isShowLoading: false)
        }
    }
    
    @objc func handleSearchViewController() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
      // MARK: - Actions
    @IBAction func handleSearchView(_ sender: Any) {
        let searchView = SearchViewController()
        navigationController?.pushViewController(searchView, animated: true)
    }
}

  // MARK: - Extension tableview

extension BrowserViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTable.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell", for: indexPath) as! CategoriesTableViewCell
        cell.lblName.text = cateList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = cateList[indexPath.row].id
        let title = cateList[indexPath.row].name
        let vc = EventsByCategoriesViewController()
        vc.id = id
        vc.headerTitle = title
        navigationController?.pushViewController(vc, animated: true)
    }

}
