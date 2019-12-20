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
import Alamofire
import RealmSwift

class NearViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var map: MKMapView!
    
    let realm = try! Realm()
    
    var events : [EventsNearResponse] = []
    
    let locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 1000
        
    var centralLocationCoordinate : CLLocationCoordinate2D!
    
    var currentLocation: CLLocation!
    
    var initLong, initLat : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateObject()
        setUpCollectionView()
        locationManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            currentLocation = locationManager.location
            if initLong == nil || initLat == nil {
                initLong = 105.874993
                initLat =  21.044895
            } else {
                initLong = currentLocation.coordinate.longitude
                initLat = currentLocation.coordinate.latitude
            }
            centerMapOnLocation(location: CLLocation(latitude: initLat!, longitude: initLong!))
        }
        addArtwork()
        getListEventV2()
        print(getRadius(centralLocation: CLLocation(latitude: initLat!, longitude: initLong!)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    func getListEventV2() {
        let token = UserDefaults.standard.string(forKey: "userToken")
        if token != nil {
            getListEvent()
        } else {
            print("token is null")
            let alertLoginFailed : UIAlertController = UIAlertController(title: "Not logged in", message: "You must to login", preferredStyle: UIAlertController.Style.alert)
            let btnOK: UIAlertAction = UIAlertAction(title: "Login", style: .default, handler: {(alert: UIAlertAction!) in self.handleLoginView()})
            alertLoginFailed.addAction(btnOK)
            present(alertLoginFailed, animated: true, completion: nil)
        }
    }
    
    
    @objc func handleLoginView() {
        isLoginVC = true
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }

    func setUpCollectionView() {
        collectionVIew.dataSource = self
        collectionVIew.delegate = self
        collectionVIew.register(UINib(nibName: "EventsCell", bundle: nil), forCellWithReuseIdentifier: "EventsCell")
    }
    
    func addArtwork() {
        map.mapType = MKMapType.standard
        let artwork = Artwork(title: "My Location",
               locationName: "My Location",
               discipline: "My Location",
               coordinate: CLLocationCoordinate2D(latitude: initLat!, longitude: initLong!))
        map.addAnnotation(artwork)
    }
    
    func updateObject() {
          self.events = RealmDataBaseQuery.getInstance.getObjects(type: EventsNearResponse.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: EventsNearResponse.self)
      }
      
    func deleteObject() {
        let list = realm.objects(EventsNearResponse.self).toArray(ofType: EventsNearResponse.self)
        try! realm.write {
            realm.delete(list)
        }
    }

    func getListEvent() {
        let token = UserDefaults.standard.string(forKey: "userToken")
        let headers = [ "token": token!,
                        "Content-Type": "application/json" ]
        let queue = DispatchQueue(label: "getMap")
        queue.async {
            getDataService.getInstance.getListNearEvent(radius: 10, longitue: self.initLong!, latitude: self.initLat!, header: headers) { (json, errcode) in
                if errcode == 1 {
                    self.deleteObject()
                    self.events.removeAll()
                    let anotionLC = json!
                    _ = anotionLC.array?.forEach({ (anotion) in
                        let anotion = Artwork(title: anotion["venue"]["name"].stringValue, locationName: anotion["venue"]["name"].stringValue, discipline: anotion["venue"]["description"].stringValue, coordinate: CLLocationCoordinate2D(latitude: anotion["venue"]["geo_lat"].doubleValue, longitude: anotion["venue"]["geo_long"].doubleValue))
                        self.map.addAnnotation(anotion)
                    })
                    _ = anotionLC.array?.forEach({ (events) in
                        let events = EventsNearResponse(id: events["id"].intValue, photo: events["photo"].stringValue, name: events["name"].stringValue, descriptionHtml: events["description_html"].stringValue, scheduleStartDate: events["schedule_start_date"].stringValue, scheduleEndDate: events["schedule_end_date"].stringValue, scheduleStartTime: events["schedule_start_time"].stringValue, scheduleEndTime: events["schedule_end_time"].stringValue, schedulePermanent: events["schedule_permanent"].stringValue, goingCount: events["going_count"].intValue)
                    RealmDataBaseQuery.getInstance.addData(object: events)
                    })
                    self.updateObject()
                    self.collectionVIew.reloadData()
                    print(self.events)
                } else {
                    print("failed")
                }
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let centralLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude:  mapView.centerCoordinate.longitude)
            self.centralLocationCoordinate = mapView.centerCoordinate
           print("Radius - \(self.getRadius(centralLocation: centralLocation))")
    }


    func getRadius(centralLocation: CLLocation) -> Double {
        let topCentralLat:Double = centralLocation.coordinate.latitude -  map.region.span.latitudeDelta/2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        return radius / 1000.0
    }
}




extension NearViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return CGSize(width: self.collectionVIew.frame.width, height: self.collectionVIew.frame.height)
    }
}


