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
    
    // MARK: - Outlets
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var alert = UIAlertController()
    
    // MARK: - Varribles
    let realm = try! Realm()
    var events : [EventsNearResponse] = []
    var anotion : [Artwork] = []
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var centralLocationCoordinate : CLLocationCoordinate2D!
    var currentLocation: CLLocation!
    var initLong, initLat : Double?
    var eventLong : [Double] = []
    var eventLat : [Double] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.handleLoading(isLoading: true)
        setUpCollectionView()
        getLocation()
        getListEventV2()
        updateObject()
    }
    
    
    // MARK: - Setup Location - MapView
    
    private func getLocation() {
        locationManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() ==  .authorizedAlways) {
                currentLocation = locationManager.location
                initLong = currentLocation.coordinate.longitude
                initLat = currentLocation.coordinate.latitude
                centerMapOnLocation(location: CLLocation(latitude: initLat!, longitude: initLong!))
            } else {
                initLong = 105.874993
                initLat =  21.044895
            }
        addArtwork()
    }
    
    private func addArtwork() {
          map.mapType = MKMapType.standard
          let artwork = Artwork(title: "My Location",
                 locationName: "My Location",
                 discipline: "My Location",
                 coordinate: CLLocationCoordinate2D(latitude: initLat!, longitude: initLong!))
          map.addAnnotation(artwork)
    }
    
    // MARK: - Setup views
    
    private func setUpCollectionView() {
          collectionVIew.dataSource = self
          collectionVIew.delegate = self
          collectionVIew.register(UINib(nibName: "EventsCell", bundle: nil), forCellWithReuseIdentifier: "EventsCell")
    }
    

    private func getListEventV2() {
        let token = UserDefaults.standard.string(forKey: "userToken")
        if token != nil {
            getListEvent()
        } else {
            alert.createAlertWithHandle(target: self, title: "Not logged in", message: "You must to login", titleBtn: "Login") {
                self.handleLoginView()
            }
        }
    }
    
    
    @objc func handleLoginView() {
        isLoginVC = true
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

  // MARK: - getData
    
    private func updateObject() {
        let list = RealmDataBaseQuery.getInstance.getObjects(type: EventsNearResponse.self)!.sorted(byKeyPath: "goingCount", ascending: false).toArray(ofType: EventsNearResponse.self)
        if list == [] {
            events.append(EventsNearResponse(id: 0, photo: "", name: "No event near you", descriptionHtml: "", scheduleStartDate: "", scheduleEndDate: "", scheduleStartTime: "", scheduleEndTime: "", schedulePermanent: "", goingCount: 0))
        } else {
            events = list
        }
    }
      
    private func getListEvent() {
        let usertoken = UserDefaults.standard.string(forKey: "userToken")
        let headers = [ "Authorization": "Bearer \(usertoken!)",
        "Content-Type": "application/json"  ]
        getDataService.getInstance.getListNearEvent(radius: 10, longitue: self.initLong!, latitude: self.initLat!, header: headers) { (eventsNear, anotionLC ,errcode) in
            if errcode == 1 {
                self.updateObject()
                self.collectionVIew.reloadData()
            } else if errcode == 2 {
                self.events.removeAll()
                _ = anotionLC?.array?.forEach({ (anotion) in
                    let anotionArt = Artwork(anotion: anotion, coordinate: CLLocationCoordinate2D(latitude: anotion["venue"]["geo_lat"].doubleValue, longitude: anotion["venue"]["geo_long"].doubleValue))
                    self.map.addAnnotation(anotionArt)
                self.eventLong.append(anotion["venue"]["geo_long"].doubleValue)
                    self.eventLat.append(anotion["venue"]["geo_lat"].doubleValue)
                })
                self.events = eventsNear
                self.updateObject()
                self.collectionVIew.reloadData()
            } else {
                self.updateObject()
                self.collectionVIew.reloadData()
            }
            self.loading.handleLoading(isLoading: false)
        }
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    private func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let centralLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude:  mapView.centerCoordinate.longitude)
            self.centralLocationCoordinate = mapView.centerCoordinate
           print("Radius - \(self.getRadius(centralLocation: centralLocation))")
    }


    private func getRadius(centralLocation: CLLocation) -> Double {
        let topCentralLat:Double = centralLocation.coordinate.latitude -  map.region.span.latitudeDelta/2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        return radius / 1000.0
    }
}


// MARK: - Extension collection view

extension NearViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCell", for: indexPath) as! EventsCell
        let queue = DispatchQueue(label: "loadImageNear")
        queue.async {
            DispatchQueue.main.async {
                cell.imgEvent.image = UIImage(data: self.events[indexPath.row].photo)
            }
        }
        cell.eventName.text = events[indexPath.row].name
        cell.eventDes.text = events[indexPath.row].descriptionHtml
        cell.eventCount.text = "\(events[indexPath.row].scheduleStartDate) - \(events[indexPath.row].goingCount) people going"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionVIew.frame.width, height: self.collectionVIew.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userToken = UserDefaults.standard.string(forKey: "userToken")
        if userToken == nil {
            loading.handleLoading(isLoading: false)
        } else {
            if eventLat == [] || eventLong == [] {
                print("No event near")
            } else {
                centerMapOnLocation(location: CLLocation(latitude: eventLat[indexPath.row], longitude: eventLong[indexPath.row]))
            }
        }
    }
}


