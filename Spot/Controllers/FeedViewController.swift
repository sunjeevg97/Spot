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
    var nameGlobal : String = "";
    var usernameGlobal : String = "";

    override func viewDidLoad() {
        
        nameGlobal = "test"
        usernameGlobal = "test"
        
        
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))

        
        
        
        tableView.dataSource = self
        loadPosts()
        
        var post = Post(captionText: "test", photoURLString: "url1")
        

        setUserValues()
        
        
        
        print("global",nameGlobal)
        print("global",usernameGlobal)
        
        
        
    }
    
    
    
    
    func loadPosts(){
        

    }
    
    
    func setUserValues() {
        
        
        
        //This is asyncronous, is returning a promise before it is finished executing
        
        //This is getting the name and username but is somehow not storing then in the global variables properly
        db.collection("users").document(id).getDocument { (snapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else{
                
                self.nameGlobal = snapshot?.get("name") as! String
                self.usernameGlobal = snapshot?.get("username") as! String
                
                print("local", self.nameGlobal)
                print("local", self.usernameGlobal)
            }
            
        }
        
        
    }
    
    
    
    
    

   

}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        
//        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.gray
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
        
    }
    
    
    
    
}

