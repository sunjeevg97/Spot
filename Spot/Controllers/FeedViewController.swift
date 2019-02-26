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

    override func viewDidLoad() {
        
        var nameGlobal = "";
        var usernameGlobal = "";
        
        nameGlobal = "test"
        usernameGlobal = "test"
        
        
        super.viewDidLoad()
        
        //This is getting the name and username but is somehow not storing then in the global variables properly
        db.collection("users").document(id).getDocument { (snapshot, err) in
            
            nameGlobal = snapshot?.get("name") as! String
            usernameGlobal = snapshot?.get("username") as! String
            
            print("local", nameGlobal)
            print("local", usernameGlobal)
            
        }
        

        print("global",nameGlobal)
        print("global",usernameGlobal)
        
        
        tableView.dataSource = self
        
//        loadPosts()
        

        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))
    }
    
    
//    func loadPosts(){
////        Firestore.collection(<#T##Firestore#>)
//
//
//    }

   

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

