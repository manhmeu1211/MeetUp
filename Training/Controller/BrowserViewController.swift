//
//  BrowserViewController.swift
//  Training
//
//  Created by ManhLD on 12/11/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {

    @IBOutlet weak var categoriesTable: UITableView!
    
    var cateList : [CategoriesResDatabase] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButton()
        setupTable()
        getListCategories()
        updateObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUpBarButton() {
        self.title = "Categories"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(handleSearchViewController))
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
        for i in cateList {
            RealmDataBaseQuery.getInstance.deleteData(object: i)
        }
    }
    
    @objc func handleSearchViewController() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
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
    
    
    
}
