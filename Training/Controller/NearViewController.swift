//
//  NearViewController.swift
//  Training
//
//  Created by ManhLD on 12/13/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NearViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 21.044919, longitude: 105.875016)
    var latValue, longValue : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map Events"
        centerMapOnLocation(location: initialLocation)
        addArtwork()
    }
    
    func addArtwork() {
        map.mapType = MKMapType.standard
        let artwork = Artwork(title: "MM's House",
               locationName: "Home",
               discipline: "My Home",
               coordinate: CLLocationCoordinate2D(latitude: 21.044919, longitude: 105.875016))
             map.addAnnotation(artwork)
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
}
