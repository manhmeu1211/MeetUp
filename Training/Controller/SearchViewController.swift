//
//  SearchViewController.swift
//  Training
//
//  Created by ManhLD on 12/12/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        addNavigationbar()
    }

    func addNavigationbar() {
         let search = UISearchController(searchResultsController: nil)
          search.searchResultsUpdater = self
          search.obscuresBackgroundDuringPresentation = false
          search.searchBar.placeholder = "Type something here to search"
          navigationItem.searchController = search
    }

      func searchControllerWith(searchResultsController: UIViewController?) -> UISearchController {
          let searchController = UISearchController(searchResultsController: searchResultsController)
          searchController.delegate = self
          searchController.searchResultsUpdater = self
          searchController.searchBar.delegate = self
          searchController.hidesNavigationBarDuringPresentation = false
          searchController.dimsBackgroundDuringPresentation = true

          return searchController
      }
 

}
