//
//  SpotPagePostViewController.swift
//  Spot
//
//  Created by Sunjeev Gururangan on 4/21/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreLocation

class SpotPagePostViewController: UIViewController {

    var spotID : String?
  
    let db = Firestore.firestore()
    let id: String = Auth.auth().currentUser?.uid ?? "invalid ID"
    var nameGlobal : String?;
    var usernameGlobal : String?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadSpots(currentspot: self.spotID!)
        
        
        
    }
    
    
    @IBAction func createPost(_ sender: Any) {
        self.performSegue(withIdentifier: "postToCreatePost", sender: self )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(self.spotId)
        if segue.identifier == "postToCreatePost"{
            //if let destination = segue.destination as? UITabBarController,
            if let vc = segue.destination as? CreatePostViewController{
                vc.spotID = self.spotID
            }
        }
    }
    
    
    
    
    
    
    
    func loadSpots(currentspot : String) {
        
        
        self.db.collection("spots").document(currentspot).getDocument(completion: { (spotSnapshot, spotsErr) in
            
            self.db.collection("users").document(self.id).getDocument { (userSnapshot, userErr) in
                
                if (userErr != nil) {
                    print("Error getting documents: \(userErr)")
                } else{
                    
                    self.nameGlobal = userSnapshot?.get("name") as? String
                    self.usernameGlobal = userSnapshot?.get("username") as? String
                    
                }
                
                self.db.collection("spots").document(currentspot).collection("feedPost").getDocuments { (querysnapshot, err) in
                    for document in querysnapshot!.documents {
                        
                        print("feedpost for nearby")
                        print("\(document.documentID) => \(document.data())")
                        
                        let spotName : String = spotSnapshot?.get("spot name") as! String
                        let captionText : String = document.get("caption") as! String
                        let imgURL : String = document.get("image url") as! String
                        
                        let imgReference = Storage.storage().reference(forURL: imgURL)
                        
                        let timestamp = document.get("timestamp")
                        let posterID : String = document.get("posterID") as! String
                        
                        
                        
                        self.db.collection("users").document(posterID).getDocument(completion: { (posterSnapshot, posterErr) in
                            
                            let posterUserName : String = posterSnapshot?.get("username") as! String
                            
                            let arrayLocation = spotSnapshot?.get("l") as! [NSNumber]
                            
                            let spotLatitude : Double = arrayLocation[0] as! Double
                            let spotLongitude : Double = arrayLocation[1] as! Double
                            
                            let convertedLocation = CLLocation(latitude: spotLatitude, longitude: spotLongitude);
                            
                            CLGeocoder().reverseGeocodeLocation(convertedLocation, completionHandler: { (placemarks, error) -> Void in
                                
                                let cityName: String = placemarks?[0].locality ?? "City"
                                let stateName: String = placemarks?[0].administrativeArea ?? "Earth"
                                
                                let cityAndState : String = cityName + ", " + stateName
                                
                                print("placemarker: ", cityAndState)
                                
                                
                                DispatchQueue.main.async {
                                    
                                    //Extract image and put it into a Post object
                                    imgReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                        if error != nil {
                                            print("error occured")
                                        } else {
                                            let image = UIImage(data: data!)!
                                            
                                            print("newpost")
                                            print(spotName,captionText,posterID)
                                            
                                            
//                                            if self.index <= 10{
//
//                                                self.postsList[self.index].spotname = spotName
//                                                self.postsList[self.index].caption = captionText
//                                                self.postsList[self.index].photo = image
//                                                self.postsList[self.index].uName = posterUserName
//                                                self.postsList[self.index].numLikes = 0
//                                                self.postsList[self.index].location = cityAndState
//
//
//
//                                            }else{
//                                                self.postsList.append(Post(spotname: spotName, captionText: captionText, photoObj: image, uNameString: posterUserName, likesCount: 0, location: cityAndState))
//
//                                            }
//
//                                            self.index = self.index + 1
//
//
//                                            print("posts list", self.postsList)
//                                            var counter = self.postsList.count
//                                            for track in 0...(counter-1){
//                                                print(self.postsList[track].spotname)
//                                                print("index: ",track, "|",self.postsList[track].toString())
//                                            }
                                            
                                          
                                            
                                        }
                                    } // End get image data
                                    
                                }
                                
                                
                                
                            }) // End reverse geocode location
                            
                            
                        }) // End get user that created the post
                    } // End loop through all feed post documents
                    
                    
                    
                } // End get collection of all feed post documents
            } // End get current user information
        }) //End get nearby spot
        
        
    } //End function GeoRunDispatch

}
