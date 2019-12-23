//
//  CategoriesTableViewCell.swift
//  Training
//
//  Created by ManhLD on 12/11/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.setUpCardView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
