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
    var email: String = ""
    var db: Firestore!

    

    override func viewDidLoad() {
        
        db = Firestore.firestore()
        
        email = Auth.auth().currentUser?.email ?? "Invalid User"
        
        
        let id: String = Auth.auth().currentUser?.uid ?? "invalid ID"
        print("UserID: ", id)
        

    
        db.collection("users").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    for document in snapshot!.documents {
                        let name = document.data()["name"] as! String
                        let username = document.data()["username"] as! String
                        
                        print(name)
                        print(username)
                        

                    }
                }
            }
        

        
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        loadPosts()
        

        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))
    }
    
    
    func loadPosts(){
//        Firestore.collection(<#T##Firestore#>)
        
        
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

