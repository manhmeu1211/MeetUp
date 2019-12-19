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

class NearViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var collectionVIew: UICollectionView!
 
    
    @IBOutlet weak var map: MKMapView!

    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 21.044919, longitude: 105.875016)
    var latValue, longValue : Double!
    var events : [EventsNearResponse] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: initialLocation)
        updateObject()
        addArtwork()
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getListEventV2()
    }
    
    func getListEventV2() {
        if token != nil {
            getListEvent()
        } else {
            ToastView.shared.short(self.view, txt_msg: "Not logged in!")
            let event = EventsNearResponse(id: 0, photo: "https://agdetail.image-gmkt.com/105/092/472092105/img/cdn.shopify.com/s/files/1/0645/2551/files/qoo10_03ed8677a499a4fbc2e046a81ee99c7c.png", name: "You have to login first", descriptionHtml: "", scheduleStartDate: "", scheduleEndDate: "", scheduleStartTime: "", scheduleEndTime: "", schedulePermanent: "", goingCount: 0)
            self.events.append(event)
        }
    }

    func setUpCollectionView() {
        collectionVIew.dataSource = self
        collectionVIew.delegate = self
        collectionVIew.register(UINib(nibName: "EventsCell", bundle: nil), forCellWithReuseIdentifier: "EventsCell")
    }
    
    func addArtwork() {
        map.mapType = MKMapType.standard
        let artwork = Artwork(title: "MM's House",
               locationName: "Home",
               discipline: "My Home",
               coordinate: CLLocationCoordinate2D(latitude: 21.044919, longitude: 105.875016))
             map.addAnnotation(artwork)
    }
    
    func updateObject() {
          self.events = RealmDataBaseQuery.getInstance.getObjects(type: EventsNearResponse.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: EventsNearResponse.self)
      }
      
      
      func deleteObject() {
          for i in self.events {
              RealmDataBaseQuery.getInstance.deleteData(object: i)
          }
      }

    func getListEvent() {
          let headers = [
              "token": token!,
              "Content-Type": "application/json"
          ]
        getDataService.getInstance.getListNearEvent(radius: 100, longitue: "105.875016", latitude: "21.044919", header: headers) { (json, errcode) in
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
            } else {
                print("failed")
            }
        }
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
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
        return CGSize(width: self.collectionVIew.frame.size.width, height: self.collectionVIew.frame.size.height)
    }

    
}
