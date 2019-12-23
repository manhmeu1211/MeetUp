//
//  DetailVenueCell.swift
//  Training
//
//  Created by ManhLD on 12/20/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class DetailVenueCell: UITableViewCell {

    @IBOutlet weak var btnFollow: UIButton!
    
    @IBOutlet weak var vnName: UILabel!
    
    @IBOutlet weak var vnDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
     override func layoutSubviews() {
        super.layoutSubviews()
        btnFollow.layoutIfNeeded()
        btnFollow.roundedButton()
       }
    
    
    @IBAction func btnFollowThis(_ sender: Any) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
