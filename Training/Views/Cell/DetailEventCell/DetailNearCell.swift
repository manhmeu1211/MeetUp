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
    
    var events : [EventsNearResponse] = []
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpVỉew()
    }
    
    
    func updateData(eventLoaded : [EventsNearResponse]) {
        if eventLoaded == [] {
            events.append(EventsNearResponse(id: 0, photo: "", name: "No data", descriptionHtml: "", scheduleStartDate: "", scheduleEndDate: "", scheduleStartTime: "", scheduleEndTime: "", schedulePermanent: "", goingCount: 0))
        } else {
            events = eventLoaded
        }
        nearCollection.reloadData()
    }
  
    
    func setUpVỉew() {
        nearCollection.delegate = self
        nearCollection.dataSource = self
        nearCollection.register(UINib(nibName: "EventsCell", bundle: nil), forCellWithReuseIdentifier: "EventsCell")
        nearCollection.showsHorizontalScrollIndicator = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension DetailNearCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCell", for: indexPath) as! EventsCell
        DispatchQueue.main.async {
                   cell.imgEvent.image = UIImage(data: self.events[indexPath.row].photo)
               }
               cell.eventName.text = events[indexPath.row].name
               cell.eventDes.text = events[indexPath.row].descriptionHtml
               cell.eventCount.text = "\(events[indexPath.row].scheduleStartDate) - \(events[indexPath.row].goingCount) people going"
        return cell
    }
    
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: nearCollection.frame.width, height: nearCollection.frame.height)
     }
}
