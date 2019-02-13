//
//  ResetViewController.swift
//  Spot
//
//  Created by Vatsal Parikh on 2/13/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

//This file controls the resetView
class ResetViewController: UIViewController {
    
    //Fields for resetView View Controller
    
    @IBOutlet weak var resetTextField: UITextField!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        
        //run handleLogin() when submit button is clicked
        resetPasswordBtn.addTarget(self, action: #selector(handleResetNew), for: .touchUpInside)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @objc func handleResetNew(_sender: AnyObject){
        
        guard let resetText = resetTextField.text else{return}
    
       if !isValidEmail(email: resetText){
            print("Please enter a valid email")
        }else{
            Auth.auth().sendPasswordReset(withEmail: resetText, completion: nil)
        
        //Currently this proceeds to next page even if you enter an email that is not in the database. Need to check whether sendPasswordReset() was successful or not
        self.performSegue(withIdentifier: "EmailSent", sender: self) //Go resetPrompt view
         
        }
        
        
        
    }
    
    
    //checks to see if valid email is entered
    func isValidEmail(email:String?) -> Bool {
        guard email != nil else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }




}
