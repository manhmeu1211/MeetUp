//
//  DetailNearCell.swift
//  Training
//
//  Created by ManhLD on 12/20/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class DetailNearCell: UITableViewCell {

    @IBOutlet weak var nearCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpVỉew()
    }
    
    func setUpVỉew() {
        nearCollection.delegate = self
        nearCollection.dataSource = self
        nearCollection.register(UINib(nibName: "EventsCell", bundle: nil), forCellWithReuseIdentifier: "EventsCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension DetailNearCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCell", for: indexPath) as! EventsCell
        
        return cell
    }
    
    
     
}
