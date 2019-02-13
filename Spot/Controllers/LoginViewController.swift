//
//  LoginViewController.swift
//  Spot
//
//  Created by Vatsal Parikh on 2/13/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        
        //run handleLogin() when button is clicked
        submitButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func handleLogin(_sender: AnyObject){
        guard let email = emailTextField.text else{return}
        guard let password = pwdTextField.text else{return}
        
        //Authenticate login information
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil && user != nil {//if no errors then allow login
                print("success!")
                self.performSegue(withIdentifier: "loginToTab", sender: self) //Go to tab view page
            }else{
                print("login failed")
            }
            
        }
        
        
        
        
        
    }
    

    

}
