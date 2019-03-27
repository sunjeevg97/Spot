//
//  LogoutView.swift
//  Spot
//
//  Created by Vatsal Parikh on 3/27/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase

class LogoutView: UIViewController {


    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        logoutBtn.isUserInteractionEnabled = true
        let logoutRecognizer = UITapGestureRecognizer(target: self, action: #selector(logoutFunc))
        logoutBtn.addGestureRecognizer(logoutRecognizer)
        
    }
    
        @objc func logoutFunc(_sender: AnyObject){
            
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
            
            
            print("logout complete 1")
            self.performSegue(withIdentifier: "logoutSegue", sender: self) //return to signup view
            print("logout complete 2")
        }
    

}
