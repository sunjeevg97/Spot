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

    override func viewDidLoad() {
        
        nameGlobal = "test"
        usernameGlobal = "test"
        
        
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))

        
        
        
        tableView.dataSource = self
        loadPosts()
        
        
        
        let group = DispatchGroup()
        group.enter()

        DispatchQueue.main.async{
            
            //Bright futures google swift futures libary
            
            //This is asyncronous, is returning a promise before it is finished executing
            //This is getting the name and username but is somehow not storing then in the global variables properly
            
            self.db.collection("users").document(self.id).getDocument { (snapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else{
                    
                    self.nameGlobal = snapshot?.get("name") as! String ?? "failed"
                    self.usernameGlobal = snapshot?.get("username") as! String ?? "failed"
                    
                    group.leave()
                }
                
            }
        
        }
        
        group.notify(queue: .main){
            print("global",self.nameGlobal)
            print("global",self.usernameGlobal)

        }
        
        
        
    }
    
    
    
    
    func loadPosts(){
        

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

