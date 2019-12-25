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
    
    private var alertLoading = UIAlertController()
    private let refreshControl = UIRefreshControl()
    private var cateList : [CategoriesResDatabase] = []
    private let realm = try! Realm()
    private let userToken = UserDefaults.standard.string(forKey: "userToken")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLoading.createAlertLoading(target: self, isShowLoading: true)
        setUpBarButton()
        setupTable()
        getCateGories()
    }
    
     // MARK: - setup View
    
    private func getCateGories() {
        let list = realm.objects(CategoriesResDatabase.self).toArray(ofType: CategoriesResDatabase.self)
        if list == [] {
            getListCategories()
        } else {
            updateObject()
        }
    }
    private func setUpBarButton() {
        self.title = "Categories"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(handleSearchViewController))
          self.tabBarController?.tabBar.isHidden = false
    }

  
    private func setupTable() {
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
    
    private func updateObject() {
        let list = (RealmDataBaseQuery.getInstance.getObjects(type: CategoriesResDatabase.self)?.toArray(ofType: CategoriesResDatabase.self))!
        cateList = list
        dismiss(animated: true, completion: nil)
    }
    
    
    private func deleteObject() {
        let list = realm.objects(CategoriesResDatabase.self).toArray(ofType: CategoriesResDatabase.self)
        try! realm.write {
            realm.delete(list)
        }
    }
       
    
    private func getListCategories() {
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
        }
        self.dismiss(animated: true, completion: nil)
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
