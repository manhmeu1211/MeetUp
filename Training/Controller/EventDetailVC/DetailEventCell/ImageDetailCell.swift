//
//  ImageDetailCell.swift
//  Training
//
//  Created by ManhLD on 12/27/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class ImageDetailCell: UITableViewCell {

    @IBOutlet weak var backGroundStatus: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imgDetail.layoutIfNeeded()
        imgDetail.roundCorners()
        backGroundStatus.setUpBGView()
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
