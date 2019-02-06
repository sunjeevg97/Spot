//
//  ViewController.swift
//  Spot
//
//  Created by Sunjeev Gururangan on 2/4/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class SignUpViewController: UIViewController {

    //set up connections b/w text fields & buttons in storyboard
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        
        //run handleSignUp() when button is clicked
        signUpBtn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @objc func handleSignUp(_sender: AnyObject){
        guard let name = nameTextField.text else{return}
        guard let username = userNameTextField.text else{return}
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        
        //authenticate user
        Auth.auth().createUser(withEmail: email, password: password){
            user, error in
            if error == nil && user != nil { //if no errors
                print("user created")
                self.saveUserToFirebase(name:name, username: username, email: email)
            }
            else{
                print(error?.localizedDescription)
            }
            
        }
    }
    
    //add new user's account to firestore w/ uid key and name,email,username value pairs
    private func saveUserToFirebase(name: String, username: String, email: String){
        let db = Firestore.firestore()
        
        guard let userId = Auth.auth().currentUser?.uid else{return}
        
        let values = ["name" : name,
                      "email" : email,
                      "username" : username]
        
        let accountInfo = [userId : values]
        
        db.collection("users").document(userId).setData(accountInfo, merge: true)
        
    }
    
}

