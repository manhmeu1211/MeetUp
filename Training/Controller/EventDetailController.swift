//
//  EventDetailController.swift
//  Training
//
//  Created by ManhLD on 12/20/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class EventDetailController: UIViewController {
    var id : Int?
    
    @IBOutlet weak var detailTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self)
        setUpView()
    }
    
    func setUpView() {
        detailTable.dataSource = self
        detailTable.delegate = self
        detailTable.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        detailTable.register(UINib(nibName: "TextAreaCell", bundle: nil), forCellReuseIdentifier: "TextAreaCell")
        detailTable.register(UINib(nibName: "DetailVenueCell", bundle: nil), forCellReuseIdentifier: "DetailVenueCell")
        detailTable.register(UINib(nibName: "DetailNearCell", bundle: nil), forCellReuseIdentifier: "DetailNearCell")
        detailTable.register(UINib(nibName: "ButtonFooterCell", bundle: nil), forCellReuseIdentifier: "ButtonFooterCell")
        detailTable.rowHeight = UITableView.automaticDimension
    }



}

extension EventDetailController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            DispatchQueue.main.async {
                cell.imgTimer.image = UIImage(named: "Group15")
                cell.date.textColor = UIColor(rgb: 0x5D20CD)
            }
            return cell
        }
        else if indexPath.row == 1 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "TextAreaCell", for: indexPath) as! TextAreaCell
            cell.txtView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            return cell
        } else if indexPath.row == 2 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailVenueCell", for: indexPath) as! DetailVenueCell
                 //set the data here
            return cell
        } else if indexPath.row == 3 {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailNearCell", for: indexPath) as! DetailNearCell
                 //set the data here
            return cell
        } else {
            let cell = detailTable.dequeueReusableCell(withIdentifier: "ButtonFooterCell", for: indexPath) as! ButtonFooterCell
                 //set the data here
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
