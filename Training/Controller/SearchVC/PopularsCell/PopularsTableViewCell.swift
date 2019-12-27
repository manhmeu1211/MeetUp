//
//  PopularsTableViewCell.swift
//  Training
//
//  Created by ManhLD on 12/11/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class PopularsTableViewCell: UITableViewCell {


    @IBOutlet weak var imgPopulars: UIImageView!
    
    
    @IBOutlet weak var eventsName: UILabel!
    

    @IBOutlet weak var desHTML: UILabel!
    
    @IBOutlet weak var dateAndCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgPopulars.layoutIfNeeded()
        imgPopulars.roundCorners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
