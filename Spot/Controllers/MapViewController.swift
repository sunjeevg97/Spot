//
//  MapViewController.swift
//  Spot
//
//  Created by Victoria Elaine Maxwell on 2/15/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore
import FirebaseStorage

class MapViewController: UIViewController {
    
    //Change status bar theme color white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    
    let db: Firestore! = Firestore.firestore()
    let id: String = Auth.auth().currentUser?.uid ?? "invalid user"
    
    let rainbowSpot = UIImage(named: "RainbowSpotIcon")
    let blackSpot = UIImage(named: "BlackSpotIcon")
    let greenSpot = UIImage(named: "GreenSpotIcon")
    
    var spots: [String: [String: Any]] = [:]
    
    var markers: [GMSMarker] = []
    
    private var infoWindow = MarkerInfoWindow()
    var locationMarker : GMSMarker? = GMSMarker()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))
        
        mapView.delegate = self
        locationManager.delegate = self
        startLocationServices()
        
        loadSpotsFromDB()
    }
    
    
    @IBAction func moveToMyLocation(_ sender: UIButton) {
        
        guard let lat = mapView.myLocation?.coordinate.latitude,
            let lng = mapView.myLocation?.coordinate.longitude else { return }
        
        let myLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapView.animate(toLocation: myLocation)
    }
    

    @IBAction func addSpot(_ sender: Any) {
        
    }
    
    func startLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            //Do something if access to location services is denied; notify user that app can't be used without authorization
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            break
            
        }
    }

    
    //getting spots from database
    func loadSpotsFromDB() {
        db.collection("spots").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let description = document.get("description")
                    let location = document.get("location") as? GeoPoint
                    let privacyLevel = document.get("privacyLevel")
                    let spotName = document.get("spotName")
                    self.spots[id] = ["description": description, "latitude": location?.latitude, "longitude": location?.longitude, "privacyLevel": privacyLevel, "spotName": spotName]
                    
                }
                
                self.loadSpotsToMap()
            }
        }
    }
    
    //making markers to add to map
    func loadSpotsToMap() {
        var lat: Double?
        var lon: Double?
        var privacy: String?
        
        for (spot, data) in spots {
            lat = data["latitude"] as? Double
            lon = data["longitude"] as? Double
            privacy = data["privacyLevel"] as? String
            
            let markerPos = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            
            let marker = GMSMarker(position: markerPos)
            
            if (privacy == "private") {
                marker.icon = blackSpot
            } else if (privacy == "friends") {
                marker.icon = greenSpot
            } else {
                marker.icon = rainbowSpot
            }
            
            marker.isFlat = true
            marker.map = mapView
            marker.userData = data
            markers.append(marker)
        }
    }
    
    //making instance of view for info window
    func loadNiB() -> MarkerInfoWindow {
        let infoWindow = MarkerInfoWindow.instanceFromNib() as! MarkerInfoWindow
        return infoWindow
    }

}

//delegate to handle location related events
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse, status == .authorizedAlways else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last as? CLLocation else {
            return
        }
        
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.pausesLocationUpdatesAutomatically = true
        //locationManager.stopUpdatingLocation()
    }
    
}

//delegate to handle events from the map
extension MapViewController: GMSMapViewDelegate {
    
    //creating info window for marker
     func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        var markerData: Dictionary<String, Any>?
        if let data = marker.userData! as? Dictionary<String, Any> {
            markerData = data
        }

        infoWindow = loadNiB()
        infoWindow.spotData = markerData
     
        let description = markerData!["description"] as? String
        let title = markerData!["spotName"] as? String
        //let img = UIImageView(image: UIImage(named: "Signuplogo"))
        
        infoWindow.titleLabel.text = title
        infoWindow.descriptionLabel.text = description
        //infoWindow.spotImage = img
        
        
     
        return infoWindow
     }
    
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("did tap marker")
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("tapped on map")
    }
    
}
