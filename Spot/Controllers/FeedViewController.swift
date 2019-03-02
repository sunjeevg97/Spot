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
        
        tableView.rowHeight = 510
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
        let handleDisplay = UILabel(frame: CGRect(x: 46, y: 8, width: 37, height: 15))
        handleDisplay.lineBreakMode = .byWordWrapping
        handleDisplay.numberOfLines = 0
        handleDisplay.textColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1)
        let handleContent = "tyler"
        let handleString = NSMutableAttributedString(string: handleContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!
            ])
        let handleRange = NSRange(location: 0, length: handleString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        handleString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: handleRange)
        handleDisplay.attributedText = handleString
        handleDisplay.sizeToFit()
        cell.addSubview(handleDisplay)
        
        
        //Display the name of the post's location
        let textLayer = UILabel(frame: CGRect(x: 196, y: 0, width: 172, height: 19))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        textLayer.textAlignment = .right
        let textContent = "Caffe Driade"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 18)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.69, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        cell.addSubview(textLayer)
        
        
        //Display the city of the location
        let city = UILabel(frame: CGRect(x: 219, y: 20, width: 148, height: 13))
        city.lineBreakMode = .byWordWrapping
        city.numberOfLines = 0
        city.textColor = UIColor.white
        textLayer.textAlignment = .right
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
        
        
        
        return cell
        
    }
    
    
    
    
}

