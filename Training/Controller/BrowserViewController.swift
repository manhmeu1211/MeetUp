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

    @IBOutlet weak var categoriesTable: UITableView!
    
    var cateList : [CategoriesResDatabase] = []
    let realm = try! Realm()
    let userToken = UserDefaults.standard.string(forKey: "userToken")
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButton()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userToken != nil {
            getListCategories()
        } else {
            updateObject()
        }
    }
    
    func setUpBarButton() {
        self.title = "Categories"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(handleSearchViewController))
          self.tabBarController?.tabBar.isHidden = false
    }

  
    func setupTable() {
        categoriesTable.delegate = self
        categoriesTable.dataSource = self
        categoriesTable.register(UINib(nibName: "CategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesTableViewCell")
    }
    
    func getListCategories() {
        let queue = DispatchQueue(label: "loadCate")
        queue.async {
            getDataService.getInstance.getListCategories { (json, errcode) in
                if errcode == 1 {
                    self.deleteObject()
                    let data = json!
                    _ = data.array?.forEach({ (cate) in
                        let categories = CategoriesResDatabase(id: cate["id"].intValue, name: cate["name"].stringValue, slug: cate["slug"].stringValue, parentId: cate["parent_id"].intValue)
                    RealmDataBaseQuery.getInstance.addData(object: categories)
                    })
                    self.cateList = (RealmDataBaseQuery.getInstance.getObjects(type: CategoriesResDatabase.self)?.toArray(ofType: CategoriesResDatabase.self))!
                    self.categoriesTable.reloadData()
                } else {
                    ToastView.shared.short(self.view, txt_msg: "Failed to load data from server")
                }
            }
        }
    }
    
    func updateObject() {
        self.cateList = (RealmDataBaseQuery.getInstance.getObjects(type: CategoriesResDatabase.self)?.toArray(ofType: CategoriesResDatabase.self))!
    }
    
    func deleteObject() {
          let list = realm.objects(CategoriesResDatabase.self).toArray(ofType: CategoriesResDatabase.self)
          try! realm.write {
              realm.delete(list)
          }
      }
    
    @objc func handleSearchViewController() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func handleSearchView(_ sender: Any) {
        let searchView = SearchViewController()
        navigationController?.pushViewController(searchView, animated: true)
    }
}

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
