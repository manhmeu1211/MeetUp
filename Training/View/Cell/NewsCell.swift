//
//  NewsCell.swift
//  Training
//
//  Created by ManhLD on 12/17/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imgNews: UIImageView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var lblDes: UILabel!
    
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgNews.roundCorners()
        containerView.setUpCardView()
        containerView.roundCornersView(corners: [.topLeft, .topRight], radius: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

