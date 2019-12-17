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
        setUpCardView(containerView: containerView)
        imgNews.roundCorners([.topLeft, .topRight], radius: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
