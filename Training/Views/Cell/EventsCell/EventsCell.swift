//
//  EventsCell.swift
//  Training
//
//  Created by ManhLD on 12/16/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class EventsCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var eventCount: UILabel!
    @IBOutlet weak var eventDes: UILabel!
    @IBOutlet weak var eventName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.setUpCardView()
    }

}
