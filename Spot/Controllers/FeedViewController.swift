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

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let email: String = Auth.auth().currentUser?.email ?? "Invalid User"
    let db: Firestore! = Firestore.firestore()
    let id: String = Auth.auth().currentUser?.uid ?? "invalid ID"
    var nameGlobal : String?;
    var usernameGlobal : String?;
    var nametestGlobal : String?;
    var usertestGlobal : String?;

    override func viewDidLoad() {
        
        nameGlobal = "test"
        usernameGlobal = "test"
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
            DispatchQueue.global().async {
                
                self.db.collection("users").document(self.id).getDocument { (snapshot, err) in
                    
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else{
                        
                        self.nameGlobal = snapshot?.get("name") as? String
                        self.usernameGlobal = snapshot?.get("username") as? String
                        
                        //need to query list of user's friends and store them in a global variable
                        
                    }
                    
                    dispatchGroup.leave()
                    print("Did the first thing")
                    
                }
            }
            
            dispatchGroup.wait()
            print("done waiting")
            print(self.usernameGlobal)
            print(self.nameGlobal)
            
            //Need to load posts from user's friends list (order by post timestamp)
            
            self.loadPosts()
            
            //Similarly you can run a .notify block to run after all previous blocks have completed
            //            dispatchGroup.notify(queue: DispatchQueue.main) {
            //                print("Did all the things")
            //                print(self.usernameGlobal)
            //                print(self.nameGlobal)
            //            }
            
            
            
            //Repeat Process for more async blocks
            
        }
        
    }
    
    func loadPosts(){
        print("posts loaded")
        
        
    }
    
    
        
}
    
    
    
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var postsList : [Post] = []
        
        for i in 1...10{
            postsList.append(Post(captionText: "caption # \(i)", photoURLString: "images/\(i)"))
            
        }
        
        

        
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //picture height = 510
        
        tableView.rowHeight = 629
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        var postsList : [Post] = []
        for i in 1...10{
            postsList.append(Post(captionText: "caption # \(i)", photoURLString: "images/\(i)"))
            
        }
        
//        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.black
        print("height", cell.heightAnchor)
//        cell.textLabel?.textColor = UIColor.white
//        cell.textLabel?.text = "\(indexPath.row)"
//        cell.textLabel?.text = postsList[indexPath.row].caption
        
        
        
        //Display the username of the user that created the post
        let handleDisplay1 = UILabel(frame: CGRect(x: 46, y: 8, width: 37, height: 15))
        handleDisplay1.lineBreakMode = .byWordWrapping
        handleDisplay1.numberOfLines = 0
        handleDisplay1.textColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1)
        let handleContent = "user"
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
        let spotNameContent = "Place Name"
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
        let cityContent = "Chapel Hill, NC"
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
        
        
        let postImage = UIView(frame: CGRect(x: 0, y: 38, width: 380, height: 510))
        postImage.backgroundColor = UIColor.brown
        cell.addSubview(postImage)
        
        //Display username next to their caption of the post
//        handleDisplay = UILabel(frame: CGRect(x: 46, y: 560, width: 37, height: 15))
//        let handleDisplay2 = UILabel(frame: CGRect(x: 46, y: 610, width: 37, height: 15))
//
//        cell.addSubview(handleDisplay)
        
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
        let captionContent = "Caption"
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
        let likesContent = "17"
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

