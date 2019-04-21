//
//  FeedViewController.swift
//  Spot
//
//  Created by Victoria Elaine Maxwell on 2/15/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreLocation
import Geofirestore

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let email: String = Auth.auth().currentUser?.email ?? "Invalid User"
    let db: Firestore! = Firestore.firestore()
    let id: String = Auth.auth().currentUser?.uid ?? "invalid ID"
    var nameGlobal : String?;
    var usernameGlobal : String?;
    var nametestGlobal : String?;
    var usertestGlobal : String?;
    var postsList : [Post] = [];
    var fullURL: String?;
    let geoFirestoreSpots = GeoFirestore(collectionRef: Firestore.firestore().collection("spots"));
    var currentLocation : CLLocation! ;
    let locationManager : CLLocationManager = CLLocationManager();
    var userLat : Double = 0;
    var userLong : Double = 0;
    var circleQuery: GFSCircleQuery?
    var nearbySpotsList : [String] = [];
    var index : Int = 0;
    
    override func viewDidLoad() {
        
            for i in 0...10{
    
                self.postsList.append(Post(spotname: "",captionText: "", photoObj: UIImage(), uNameString: "",likesCount:0, location: ""))
    //            postsList.append(Post(spotname: "",captionText: "", photoObj: UIImage(), uNameString: "",likesCount:0, location: ""))
    
    
            }
        
        
        nameGlobal = "test"
        usernameGlobal = "test"
        nametestGlobal = "test"
        usertestGlobal = "test"
        
        //Get User's current location
        if CLLocationManager.locationServicesEnabled() == true{
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined{
                
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = 1.0
            locationManager.startUpdatingLocation()
            currentLocation = locationManager.location
            
        }else{
            print("please turn on location services")
        }
        
        userLat = currentLocation.coordinate.latitude
        userLong = currentLocation.coordinate.longitude
        
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))
        
        self.tableView.dataSource = self
        
        var testlist : [String] = []
        
        self.circleQuery = self.geoFirestoreSpots.query(withCenter: GeoPoint(latitude: self.userLat, longitude: self.userLong), radius: 0.804672)
        
        DispatchQueue.global().async {
            
            let dispatchgroup = DispatchGroup()
            
            dispatchgroup.enter()
            
            Firestore.firestore().collection("spots").getDocuments { (documentsAll, err1) in
                
                for doc in documentsAll!.documents{
                    
//                    doc.documentID
                    
                    print("alldoc ", doc)
//                    testlist.append(doc.documentID)
                    
                    self.runGeoDispatch(nearbySpotID: doc.documentID, index: self.index);
                    
                    
                    
                }
                
                dispatchgroup.leave()
                
            }
            
            dispatchgroup.wait()
            
            
            for post in self.postsList{
                print("postslist crossed ", post.spotname)
            }

            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
            
        }
        
        


        print("circleQuery", self.circleQuery)

//
//        DispatchQueue.global().async {
//            let dispatchgroup = DispatchGroup()
        
//            dispatchgroup.enter()
            
//            self.circleQuery?.observe(.documentEntered, with: { (key, location) in
//                print("The document with documentID '\(key)' entered the search area and is at location '\(location)'")
//
//                self.nearbySpotsList.append(key!);
//
//                print("incremental", self.nearbySpotsList)
//
//
//
//                self.runGeoDispatch(nearbySpotID: key!, index: self.index);
//
//    //            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
//    //            self.tableView.reloadData()
//
//            })
            
//        }

       

        //It's good to run dispatch after everything else in viewDidLoad because nothing afterwards will run before it finishes
//        runDispatch()
        
    } //End view did load
    
    
    func runGeoDispatch(nearbySpotID : String, index: Int) {
        
        let pathOfNearby = self.db.collection("spots").document(nearbySpotID)
        
        self.db.collection("spots").document(nearbySpotID).getDocument(completion: { (spotSnapshot, spotsErr) in
        
            self.db.collection("users").document(self.id).getDocument { (userSnapshot, userErr) in
                
                if (userErr != nil) {
                    print("Error getting documents: \(userErr)")
                } else{
                    
                    self.nameGlobal = userSnapshot?.get("name") as? String
                    self.usernameGlobal = userSnapshot?.get("username") as? String
                    
                }
                
                pathOfNearby.collection("feedPost").getDocuments { (querysnapshot, err) in
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
                                        
                                        


                                            if index <= 10{
                                                
                                                self.postsList[index].spotname = spotName
                                                self.postsList[index].caption = captionText
                                                self.postsList[index].photo = image
                                                self.postsList[index].uName = posterUserName
                                                self.postsList[index].numLikes = 0
                                                self.postsList[index].location = cityAndState
                                                
                                                self.index = index + 1
                                                
                                            }else{
                                                self.postsList.append(Post(spotname: spotName, captionText: captionText, photoObj: image, uNameString: posterUserName, likesCount: 0, location: cityAndState))
                                                
                                                self.index = index + 1

                                            }
                                        
                                        

                                        
                                        print("posts list", self.postsList)
                                        var counter = self.postsList.count
                                        for index in 0...(counter-1){
                                                print(self.postsList[index].spotname)
                                        }
                                        
//                                        self.index = index + 1
                                        
//                                        self.tableView.reloadData()
                                        
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
    
    
    func runDispatchOriginal() {
        DispatchQueue.global().async {
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            self.db.collection("users").document(self.id).getDocument { (snapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else{
                    
                    self.nameGlobal = snapshot?.get("name") as? String
                    self.usernameGlobal = snapshot?.get("username") as? String
                    
                    //need to query list of user's friends and store them in a global variable
                    
                }
                
                dispatchGroup.leave()
                
            }
            
            dispatchGroup.wait()
            
            print("username values")
            print(self.usernameGlobal)
            print(self.nameGlobal)
            
            
            //Need to load posts from user's friends list (order by post timestamp or location)
            
            
            
            for index in 0...4{
                
                dispatchGroup.enter()
                
                let spotID : String = "NZNdh5JLF3xwFykXubdY"
                
                let pathOfPost = self.db.collection("spots").document(spotID)
                
                pathOfPost.getDocument(completion: { (snapshot, err) in
                    
                    
                    
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }else{
                        self.postsList[index].spotname = snapshot?.get("spotName") as! String
                        
                        let arrayLocation = snapshot?.get("l") as! [NSNumber]
                        
                        print("arrayLocation",arrayLocation as! [Double])
                        

                        
                        let latitude : Double = arrayLocation[0] as! Double
                        let longitude : Double = arrayLocation[1] as! Double
                        
                        
                        let convertedLocation = CLLocation(latitude: latitude, longitude: longitude);
                        
                        CLGeocoder().reverseGeocodeLocation(convertedLocation, completionHandler: { (placemarks, error) -> Void in
                            
                            let cityName: String = placemarks?[0].locality ?? "City"
                            let stateName: String = placemarks?[0].administrativeArea ?? "Earth"
                            
                            let cityAndState : String = cityName + ", " + stateName
                            
                            print("placemarker: ", cityAndState)
                            
                            self.postsList[index].location = cityAndState
                            
                        })
                        
                    }
                    
                    dispatchGroup.leave()
                })
                
                dispatchGroup.wait()
                
                
                dispatchGroup.enter()
                var imageURL:String = "";
                var posterUsername : String = "";
                
                
                pathOfPost.collection("feedPost").document("C94475D4-0585-4C9D-BAC0-70433B4E9523").getDocument{(snapshotSpot, errSpot) in
                    
                    
                    if let err = errSpot {
                        print("Error getting documents: \(err)")
                    } else{
                        print("image URL")
                        
                        let posterID = snapshotSpot?.get("posterID") as! String
                        
                        imageURL = snapshotSpot?.get("image url") as! String
                        
                        self.postsList[index].caption = (snapshotSpot?.get("caption") as! String) + ": Row " + String(index)
                        self.postsList[index].uName = snapshotSpot?.get("posterID") as! String
                        self.postsList[index].numLikes = snapshotSpot?.get("numLikes") as! Int
                        
                        
                        self.db.collection("users").document(posterID).getDocument(completion: {
                            
                            (snapshotUser, errUser) in
                            
                            posterUsername = snapshotUser?.get("username") as! String
                            
                            self.postsList[index].uName = posterUsername
                            
                            
                            
                            let gsReference = Storage.storage().reference(forURL: imageURL)
                            
                            print("reference info")
                            print(gsReference)
                            print(gsReference.fullPath)
                            print(gsReference.name)
                            //            print(gsReference.parent())
                            
                            
                            
                            //Extract image and put it into a Post object
                            gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                if error != nil {
                                    print("error occured")
                                } else {
                                    let image = UIImage(data: data!)
                                    self.postsList[index].photo = image!;
                                    
                                    self.tableView.reloadData()
                                    
                                    dispatchGroup.leave()
                                    
                                }
                            }
                            
                        })
                    }
                }
            }//End loop
            
            
            
            
            
        }
    }
    
    
    
}



extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return 10
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //picture height = 510
        
        tableView.rowHeight = 629
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
//        if cell != nil{
//            cell = UITableViewCell(style: ., reuseIdentifier: "PostCell") as! UITableViewCell
//        }
        
        //        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.black
        print("height", cell.heightAnchor)
        
        
        //Display the username of the user that created the post
        let handleDisplay1 = UILabel(frame: CGRect(x: 46, y: 8, width: 100, height: 15))
        handleDisplay1.lineBreakMode = .byWordWrapping
        handleDisplay1.numberOfLines = 0
        handleDisplay1.textColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1)
        let handleContent = self.postsList[indexPath.row].uName
        let handleString = NSMutableAttributedString(string: handleContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!
            ])
        let handleRange = NSRange(location: 0, length: handleString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        handleString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: handleRange)
        handleDisplay1.attributedText = handleString
        handleDisplay1.sizeToFit()
        cell.addSubview(handleDisplay1)
        
        
        //Display the name of the post's location
        let spotName = UILabel(frame: CGRect(x: 196, y: 0, width: 172, height: 19))
        spotName.lineBreakMode = .byWordWrapping
        spotName.numberOfLines = 0
        spotName.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        spotName.textAlignment = .right
        let spotNameContent = self.postsList[indexPath.row].spotname
        let spotNameString = NSMutableAttributedString(string: spotNameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 18)!
            ])
        let spotNameRange = NSRange(location: 0, length: spotNameString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        spotNameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: spotNameRange)
        spotNameString.addAttribute(NSAttributedString.Key.kern, value: 0.69, range: spotNameRange)
        spotName.attributedText = spotNameString
        spotName.sizeToFit()
        cell.addSubview(spotName)
        
        
        //Display the city of the location
        let city = UILabel(frame: CGRect(x: 219, y: 20, width: 148, height: 13))
        city.lineBreakMode = .byWordWrapping
        city.numberOfLines = 0
        city.textColor = UIColor.white
        city.textAlignment = .right
        let cityContent = self.postsList[indexPath.row].location
        let cityString = NSMutableAttributedString(string: cityContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 11)!
            ])
        let cityRange = NSRange(location: 0, length: cityString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.18
        cityString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: cityRange)
        city.attributedText = cityString
        city.sizeToFit()
        cell.addSubview(city)
        
        //Show the image associated with the post
        
        let postImage = UIImageView(frame: CGRect(x: 0, y: 38, width: 380, height: 510))
        //        postImage.backgroundColor = UIColor.brown
        //        cell.addSubview(postImage)
        //        postImage.image = UIImage(named: "Signuplogo.png")
        postImage.image = self.postsList[indexPath.row].photo as! UIImage
        postImage.contentMode = UIView.ContentMode.scaleAspectFit
        cell.insertSubview(postImage, at: 0)
        
        
        //Display the username in front of the caption
        let handleDisplay2 = UILabel(frame: CGRect(x: 12, y: 560, width: 37, height: 15))
        handleDisplay2.lineBreakMode = .byWordWrapping
        handleDisplay2.numberOfLines = 0
        handleDisplay2.textColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        handleString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: handleRange)
        handleDisplay2.attributedText = handleString
        handleDisplay2.sizeToFit()
        cell.addSubview(handleDisplay2)
        
        
        //Caption of post
        let captionLayer = UILabel(frame: CGRect(x: 48, y: 561, width: 270, height: 30))
        captionLayer.lineBreakMode = .byWordWrapping
        captionLayer.numberOfLines = 0
        captionLayer.textColor = UIColor.white
        var captionContent = self.postsList[indexPath.row].caption
        var captionString = NSMutableAttributedString(string: captionContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 13)!
            ])
        let captionRange = NSRange(location: 0, length: captionString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.15
        captionString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: captionRange)
        captionLayer.attributedText = captionString
        captionLayer.sizeToFit()
        cell.addSubview(captionLayer)
        
        //Display number of comments
        let numComments = UILabel(frame: CGRect(x: 30, y: 579, width: 341, height: 14))
        numComments.lineBreakMode = .byWordWrapping
        numComments.numberOfLines = 0
        numComments.textColor = UIColor.darkGray
        let commentsContent = "2 comments"
        let commentsString = NSMutableAttributedString(string: commentsContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!
            ])
        let commentsRange = NSRange(location: 0, length: commentsString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        commentsString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: commentsRange)
        numComments.attributedText = commentsString
        numComments.sizeToFit()
        cell.addSubview(numComments)
        
        //Display number of likes
        let numLikes = UILabel(frame: CGRect(x: 346, y: 560, width: 15, height: 13))
        numLikes.lineBreakMode = .byWordWrapping
        numLikes.numberOfLines = 0
        numLikes.textColor = UIColor(red:0.02, green:0.62, blue:1, alpha:1)
        numLikes.textAlignment = .center
        let likesContent = String(self.postsList[indexPath.row].numLikes)
        let likesString = NSMutableAttributedString(string: likesContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 11)!
            ])
        let likesRange = NSRange(location: 0, length: likesString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.18
        likesString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: likesRange)
        likesString.addAttribute(NSAttributedString.Key.kern, value: -0.55, range: likesRange)
        numLikes.attributedText = likesString
        numLikes.sizeToFit()
        cell.addSubview(numLikes)
        
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
    
}


