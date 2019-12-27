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
    
    @IBOutlet weak var imgTimer: UIImageView!
    
    @IBOutlet weak var imgNews: UIImageView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var lblDes: UILabel!
    
    @IBOutlet weak var backgroundStatusView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgNews.roundCorners()
        containerView.setUpCardView()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layoutIfNeeded()
        containerView.roundCornersView(corners: [.topLeft, .topRight], radius: 30)
        backgroundStatusView.setUpBGView()
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = UIColor.white
        } else {
            contentView.backgroundColor = UIColor.white
        }
    }
    
}

