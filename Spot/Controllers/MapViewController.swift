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
import Geofirestore

class MapViewController: UIViewController {
    
    //Change status bar theme color white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    
    let db: Firestore! = Firestore.firestore()
    let spotsRef = Firestore.firestore().collection("spots")
    let geoFirestore = GeoFirestore(collectionRef: Firestore.firestore().collection("spots"))
    let id: String = Auth.auth().currentUser?.uid ?? "invalid user"
    
    let rainbowSpot = UIImage(named: "RainbowSpotIcon")
    let blackSpot = UIImage(named: "BlackSpotIcon")
    let greenSpot = UIImage(named: "GreenSpotIcon")
    
    var markers: [String: GMSMarker] = [:]
    
    private var infoWindow = MarkerInfoWindow()
    var locationMarker : GMSMarker? = GMSMarker()
    
    var circleQuery: GFSCircleQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))
        
        mapView.delegate = self
        locationManager.delegate = self
        startLocationServices()
        
        circleQuery = geoFirestore.query(withCenter: GeoPoint(latitude: 35.9132, longitude: -79.0558), radius: 0.804672)
        let _ = circleQuery?.observe(.documentEntered, with: loadSpotFromDB)
        
        //setSpotLocations()
    }
    
    
    @IBAction func moveToMyLocation(_ sender: UIButton) {
        
        guard let lat = mapView.myLocation?.coordinate.latitude,
            let lng = mapView.myLocation?.coordinate.longitude else { return }
        
        let myLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapView.animate(toLocation: myLocation)
    }
    

    @IBAction func addSpot(_ sender: Any) {
        
    }
    
    //setting location for spot in database using geoFirestore
    func setSpotLocations() {
        //old well
        geoFirestore.setLocation(location: CLLocation(latitude: 35.9121, longitude: -79.0512), forDocumentWithID: "4fbapPCV0sxcnE9rdLyE") { (error) in
            if (error != nil) {
                print("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }
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

    
    //getting spot from database
    func loadSpotFromDB(key: String?, location: CLLocation?) {
        print("in load spot from db")
        if let spotKey = key, markers[key!] == nil {
            self.spotsRef.document(spotKey).getDocument { (document, error) in
                print("in get document")
                if let document = document, document.exists {
                    let description = document.get("description")
                    let lat = location?.coordinate.latitude as! Double
                    let long = location?.coordinate.longitude as! Double
                    let privacyLevel = document.get("privacyLevel") as? String
                    let spotName = document.get("spotName")
                    
                    let spotData = ["spotId": spotKey, "description": description, "latitude": lat, "longitude": long, "privacyLevel": privacyLevel, "spotName": spotName]
                    
                    self.loadSpotToMap(data: spotData)
                    
                } else {
                    print("Document does not exist")
                }
            }
                
        }
    }
    
    
    //making marker to add to map
    func loadSpotToMap(data: [String:Any]) {
        print("in load spot to map")
        let spotID = data["spotId"] as! String
        let privacyLevel = data["privacyLevel"] as? String
        guard let lat = data["latitude"] as? Double else {
            return
        }
        guard let long = data["longitude"] as? Double else {
            return
        }
        
        let markerPos = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let marker = GMSMarker(position: markerPos)
        
        if (privacyLevel == "private") {
            marker.icon = self.blackSpot
        } else if (privacyLevel == "friends") {
            marker.icon = self.greenSpot
        } else {
            marker.icon = self.rainbowSpot
        }
        
        marker.isFlat = true
        marker.map = self.mapView
        marker.userData = data
        self.markers[spotID] = marker
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
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        let lat = cameraPosition.target.latitude
        let long = cameraPosition.target.longitude
        
        circleQuery?.center = CLLocation(latitude: lat, longitude: long)
    }
}
