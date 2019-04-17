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

    override func viewDidLoad() {
        
        
        nameGlobal = "test"
        usernameGlobal = ""
        nametestGlobal = "test"
        usertestGlobal = "test"
        
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))
        
        tableView.dataSource = self
        
        //It's good to run dispatch after everything else in viewDidLoad because nothing afterwards will run before it finishes
        runDispatch()
    }

    func runDispatch() {
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
                        
                        let coordinates: GeoPoint = snapshot?.get("location") as! GeoPoint
                        let arrayLocation = snapshot?.get("l") as! [NSNumber]
                        
                        print("arrayLocation",arrayLocation as! [Double])
                        
                        var longitude: Double =  coordinates.longitude
                        var latitude: Double = coordinates.latitude
                        
                        latitude = arrayLocation[0] as! Double
                        longitude = arrayLocation[1] as! Double
                        
                        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //picture height = 510
        
        tableView.rowHeight = 629
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
//        var postsList : [Post] = []
        for i in 0...10{
            
            postsList.append(Post(spotname: "",captionText: "", photoObj: UIImage(), uNameString: "",likesCount:0, location: ""))
            
            
        }
        
//        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.black
        print("height", cell.heightAnchor)

        
        //Display the username of the user that created the post
        let handleDisplay1 = UILabel(frame: CGRect(x: 46, y: 8, width: 100, height: 15))
        handleDisplay1.lineBreakMode = .byWordWrapping
        handleDisplay1.numberOfLines = 0
        handleDisplay1.textColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1)
        let handleContent = postsList[indexPath.row].uName
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
        let spotNameContent = postsList[indexPath.row].spotname
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
        let cityContent = postsList[indexPath.row].location
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
        postImage.image = postsList[indexPath.row].photo as! UIImage
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
        let captionContent = postsList[indexPath.row].caption
        let captionString = NSMutableAttributedString(string: captionContent, attributes: [
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
        let likesContent = String(postsList[indexPath.row].numLikes)
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

