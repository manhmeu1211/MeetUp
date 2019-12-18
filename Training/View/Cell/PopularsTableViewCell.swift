//
//  PopularsTableViewCell.swift
//  Training
//
//  Created by ManhLD on 12/11/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class PopularsTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var imgPopulars: UIImageView!
    
    
    @IBOutlet weak var eventsName: UILabel!
    

    @IBOutlet weak var desHTML: UILabel!
    
    @IBOutlet weak var dateAndCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCardView(containerView: containerView)
        imgPopulars.layer.cornerRadius = 20
        imgPopulars.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
