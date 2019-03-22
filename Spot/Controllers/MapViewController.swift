//
//  MapViewController.swift
//  Spot
//
//  Created by Victoria Elaine Maxwell on 2/15/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    //Change status bar theme color white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    
    let rainbowSpot = UIImage(named: "RainbowSpotIcon")
    let blackSpot = UIImage(named: "BlackSpotIcon")
    let greenSpot = UIImage(named: "GreenspotIcon")
    
    let spots: [String: [String: Any]] = [
        "spot1": ["latitude": 35.9121, "longitude": -79.0512, "spotName": "Old Well", "description": "drink from well to get 4.0 gpa", "privacyLevel": "public"],
        "spot2": ["latitude": 35.9132, "longitude": -79.0546, "spotName": "Cosmic Cantina", "description": "Mexican restaurant", "privacyLevel": "private"]]
    
    var markers: [GMSMarker] = []
    
    private var infoWindow = MarkerInfoWindow()
    var locationMarker : GMSMarker? = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        loadSpotsToMap()

    }
    
    
    
    @IBAction func moveToMyLocation(_ sender: UIButton) {
        
        guard let lat = mapView.myLocation?.coordinate.latitude,
            let lng = mapView.myLocation?.coordinate.longitude else { return }
        
        let myLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapView.animate(toLocation: myLocation)
    }
    

    @IBAction func addSpot(_ sender: Any) {
        
    }

    
    //getting spots from database
    func loadSpotsFromDB() {
        
        
    }
    
    //making markers to add to map
    func loadSpotsToMap() {
        var lat: Double? = 0
        var lon: Double? = 0
        
        for (spot, data) in spots {
            lat = data["latitude"] as? Double
            lon = data["longitude"] as? Double
            
            let markerPos = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            
            let marker = GMSMarker(position: markerPos)
            marker.icon = rainbowSpot
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
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        
        locationManager.stopUpdatingLocation()
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
