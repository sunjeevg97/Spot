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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        var postsList : [Post] = []
        for i in 1...10{
            postsList.append(Post(captionText: "caption # \(i)", photoURLString: "images/\(i)"))
            
        }
        
//        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.gray
        cell.textLabel?.text = "\(indexPath.row)"
        cell.textLabel?.text = postsList[indexPath.row].caption
        
        
        
        return cell
        
    }
    
    
    
    
}

