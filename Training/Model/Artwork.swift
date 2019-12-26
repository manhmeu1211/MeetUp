//
//  ArtWork.swift
//  Training
//
//  Created by ManhLD on 12/13/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation
import SwiftyJSON

import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D

    init(anotion : JSON, coordinate: CLLocationCoordinate2D) {
        self.title = anotion["venue"]["name"].stringValue
        self.locationName = anotion["venue"]["name"].stringValue
        self.discipline = anotion["venue"]["description"].stringValue
        self.coordinate = coordinate
        super.init()
  }
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
       self.title = title
       self.locationName = locationName
       self.discipline = discipline
       self.coordinate = coordinate
       super.init()
    }
  
  var subtitle: String? {
    return locationName
  }
    
}
