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
//    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
//    @IBOutlet weak var userNameTextField: UITextField!
    
    weak var nameField: UITextField!
    weak var emailField: UITextField!
    weak var usernameField: UITextField!
    weak var pwdField: UITextField!
    
    
    override func viewDidLoad() {
        
        //Load User Interface Elements using code from Invision
        
        //Load Spot Logo
        let logoPath = "Signuplogo1x.png"
        let logoImage = UIImage(named: logoPath)
        let logoImageView = UIImageView(image: logoImage!)
        
        logoImageView.frame = CGRect(x: 150, y: 45, width: 75, height: 22)
        view.addSubview(logoImageView)

        //Load "Rediscover Your World"
        let sloganTextLayer = UILabel(frame: CGRect(x: 99, y: 73, width: 178, height: 15))
        sloganTextLayer.lineBreakMode = .byWordWrapping
        sloganTextLayer.numberOfLines = 0
        sloganTextLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        sloganTextLayer.textAlignment = .center
        let sloganTextContent = "REDISCOVER YOUR WORLD"
        let sloganTextString = NSMutableAttributedString(string: sloganTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 13)!
            ])
        let sloganTextRange = NSRange(location: 0, length: sloganTextString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.15
        sloganTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: sloganTextRange)
        sloganTextLayer.attributedText = sloganTextString
        sloganTextLayer.sizeToFit()
        self.view.addSubview(sloganTextLayer)
        
        //Load "Create Account"
        let createAccountLayer = UILabel(frame: CGRect(x: 38, y: 108, width: 266, height: 38))
        createAccountLayer.lineBreakMode = .byWordWrapping
        createAccountLayer.numberOfLines = 0
        createAccountLayer.textColor = UIColor.white
        let createAccountContent = "Create account"
        let createAccountString = NSMutableAttributedString(string: createAccountContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 28)!
            ])
        let createAccountRange = NSRange(location: 0, length: createAccountString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.21
        createAccountString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: createAccountRange)
        createAccountLayer.attributedText = createAccountString
        createAccountLayer.sizeToFit()
        self.view.addSubview(createAccountLayer)
        
        
        //Load 'name' label
        let nameLayer = UILabel(frame: CGRect(x: 39, y: 155, width: 170, height: 16))
        nameLayer.lineBreakMode = .byWordWrapping
        nameLayer.numberOfLines = 0
        nameLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let nameContent = "name"
        let nameString = NSMutableAttributedString(string: nameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 14)!
            ])
        let textRange = NSRange(location: 0, length: nameString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.14
        nameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        nameLayer.attributedText = nameString
        nameLayer.sizeToFit()
        self.view.addSubview(nameLayer)
        
        
        //Load 'name' text field
        nameField = UITextField(frame: CGRect(x: 38, y: 174, width: 299.02, height: 36))
        nameField.layer.cornerRadius = 5
        nameField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(nameField)
        
        
        
        //Load email label
        let emailLayer = UILabel(frame: CGRect(x: 39, y: 223, width: 170, height: 16))
        emailLayer.lineBreakMode = .byWordWrapping
        emailLayer.numberOfLines = 0
        emailLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let emailContent = "email"
        let emailString = NSMutableAttributedString(string: emailContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 14)!
            ])
        let emailRange = NSRange(location: 0, length: emailString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.14
        emailString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: emailRange)
        emailLayer.attributedText = emailString
        emailLayer.sizeToFit()
        self.view.addSubview(emailLayer)
        
        //load email text field
        
        emailField = UITextField(frame: CGRect(x: 38, y: 242, width: 299.02, height: 36))
        emailField.layer.cornerRadius = 5
        emailField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(emailField)
        
        //load username label
        
        let usernameLayer = UILabel(frame: CGRect(x: 39, y: 291, width: 170, height: 16))
        usernameLayer.lineBreakMode = .byWordWrapping
        usernameLayer.numberOfLines = 0
        usernameLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let usernameContent = "username"
        let usernameString = NSMutableAttributedString(string: usernameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 14)!
            ])
        let usernameRange = NSRange(location: 0, length: usernameString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.14
        usernameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: usernameRange)
        usernameLayer.attributedText = usernameString
        usernameLayer.sizeToFit()
        self.view.addSubview(usernameLayer)
        
        //load username text field
        
        usernameField = UITextField(frame: CGRect(x: 38, y: 310, width: 299.02, height: 36))
        usernameField.layer.cornerRadius = 5
        usernameField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(usernameField)
        
        
        //load password label
        let pwdLayer = UILabel(frame: CGRect(x: 39, y: 359, width: 78, height: 16))
        pwdLayer.lineBreakMode = .byWordWrapping
        pwdLayer.numberOfLines = 0
        pwdLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let pwdContent = "password"
        let pwdString = NSMutableAttributedString(string: pwdContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 14)!
            ])
        let pwdRange = NSRange(location: 0, length: pwdString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.14
        pwdString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: pwdRange)
        pwdLayer.attributedText = pwdString
        pwdLayer.sizeToFit()
        self.view.addSubview(pwdLayer)
        
        //load pwd min characters label
        
        //load password text field
        pwdField = UITextField(frame: CGRect(x: 38, y: 378, width: 299.02, height: 36))
        pwdField.layer.cornerRadius = 5
        pwdField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(pwdField)
        
        
        
        //run handleSignUp() when button is clicked
        signUpBtn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        
        super.viewDidLoad()
        
        
        
        //Display background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "SignUpBackground.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        
        
    }
    
    
    @objc func handleSignUp(_sender: AnyObject){
        
        
        print(nameField.text!)
        
        guard let name = nameField.text else{return}
        guard let username = usernameField.text else{return}
        guard let email = emailField.text else{return}
        guard let password = pwdField.text else{return}
        
        
//        guard let name = nameTextField.text else{return}
//        guard let username = userNameTextField.text else{return}
//        guard let email = emailTextField.text else{return}
//        guard let password = passwordTextField.text else{return}
        
        
        
        
        
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

