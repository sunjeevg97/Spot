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
        
        //Checks to see if there is text field without text entered into it
        if (!self.allFieldsComplete(name: name, username: username, email: email, password: password)){
            print("complete all fields to create account")
        }else{//if there is text in all fields, proceeds to authentication
            
            Auth.auth().createUser(withEmail: email, password: password){//authenticate user
                user, error in
                
                if error == nil && user != nil { //if no errors then create user
                    print("user created")
                    self.saveUserToFirebase(name:name, username: username, email: email)
                    self.performSegue(withIdentifier: "signUpToInfo", sender: self) //Go to intro page
                }else{
                    print(error?.localizedDescription ?? "Sign-up Error")
                }
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
    
    //Function checks to see if text is entered into all fields
    private func allFieldsComplete(name:String, username:String,email:String,password:String) -> Bool{
        
        if name.isEmpty{
            print("name is empty")
            return false;
        }
        if username.isEmpty{
            print("username is empty")
            return false;
        }
        if !isValidEmail(email: email){
            print("invalid email")
            return false;
        }
        if password.count < 6{
            print("password must be at least 6 characters")
            return false;
        }
        print("all fields entered in proper format")
        return true;
    }
    
    
    //checks to see if valid email is entered
    func isValidEmail(email:String?) -> Bool {
        guard email != nil else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
}

