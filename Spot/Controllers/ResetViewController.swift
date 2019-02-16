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
    
    //Initializes text field variable
    weak var emailField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Display background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "SignUpBackground.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
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
        
        
        //Load arrow container
        let arrowContainer = UIView(frame: CGRect(x: 15, y: 56, width: 12, height: 20))
        self.view.addSubview(arrowContainer)
        
        
        //Load back arrow (top)
        let backArrowTop = UIView(frame: CGRect(x: 19.68, y: 64, width: 2.5, height: 14))
        var transformTop = CGAffineTransform.identity
        transformTop = transformTop.rotated(by: 2.356194490192345)
        backArrowTop.transform = transformTop
        backArrowTop.layer.cornerRadius = 0.75
        backArrowTop.backgroundColor = UIColor.white
        self.view.addSubview(backArrowTop)
        
        //Load back arrow (bottom)
        let backArrowBottom = UIView(frame: CGRect(x: 19.68, y: 56, width: 2.5, height: 14))
        var transformBottom = CGAffineTransform.identity
        transformBottom = transformBottom.rotated(by: -2.356194490192345)
        backArrowBottom.transform = transformBottom
        backArrowBottom.layer.cornerRadius = 0.75
        backArrowBottom.backgroundColor = UIColor.white
        self.view.addSubview(backArrowBottom)
        
        
        //loginToSignup
        arrowContainer.isUserInteractionEnabled = true
        let backRecognizer = UITapGestureRecognizer(target: self, action: #selector(returnToSignup))
        arrowContainer.addGestureRecognizer(backRecognizer)
        
        
        //Loads 'Password Reset' Label
        let resetLabel = UILabel(frame: CGRect(x: 38, y: 237, width: 313, height: 38))
        resetLabel.lineBreakMode = .byWordWrapping
        resetLabel.numberOfLines = 0
        resetLabel.textColor = UIColor.white
        let rlContent = "Password reset"
        let rlString = NSMutableAttributedString(string: rlContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 32)!
            ])
        let rlRange = NSRange(location: 0, length: rlString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.19
        rlString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: rlRange)
        resetLabel.attributedText = rlString
        resetLabel.sizeToFit()
        self.view.addSubview(resetLabel)
        
        
        
        //load email label
        let emailLayer = UILabel(frame: CGRect(x: 39, y: 291, width: 170, height: 16))
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
        emailField = UITextField(frame: CGRect(x: 38, y: 310, width: 299.02, height: 36))
        emailField.layer.cornerRadius = 5
        emailField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(emailField)
        emailField.textColor = UIColor.white
        
        
        //Load 'we'll send a link to reset your password'
        let instructLayer = UILabel(frame: CGRect(x: 38, y: 371, width: 313, height: 19))
        instructLayer.lineBreakMode = .byWordWrapping
        instructLayer.numberOfLines = 0
        instructLayer.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
        let instructContent = "We’ll send a link to reset your password"
        let instructString = NSMutableAttributedString(string: instructContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let instructRange = NSRange(location: 0, length: instructString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.19
        instructString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: instructRange)
        instructLayer.attributedText = instructString
        instructLayer.sizeToFit()
        self.view.addSubview(instructLayer)
        
        
        //Load 'Go' button background
        let resetBtnBackground = UIView(frame: CGRect(x: 134, y: 432, width: 108, height: 30))
        resetBtnBackground.layer.cornerRadius = 8
        resetBtnBackground.backgroundColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        self.view.addSubview(resetBtnBackground)
        
        //Load 'Go' button text
        let resetBtnText = UILabel(frame: CGRect(x: 145, y: 438, width: 178, height: 19))
        resetBtnText.lineBreakMode = .byWordWrapping
        resetBtnText.numberOfLines = 0
        resetBtnText.textColor = UIColor.white
        resetBtnText.textAlignment = .center
        let resetBtnContent = "EMAIL LINK"
        let resetBtnString = NSMutableAttributedString(string: resetBtnContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let resetBtnRange = NSRange(location: 0, length: resetBtnString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.19
        resetBtnString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: resetBtnRange)
        resetBtnText.attributedText = resetBtnString
        resetBtnText.sizeToFit()
        self.view.addSubview(resetBtnText)
        
        //run handleResetNew
        resetBtnBackground.isUserInteractionEnabled = true
        let resetRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleReset))
        resetBtnBackground.addGestureRecognizer(resetRecognizer)

    }
    
    @objc func returnToSignup(_sender: AnyObject){
        self.performSegue(withIdentifier: "resetToLogin", sender: self) //return to signup view
    }
    
    
    @objc func handleReset(_sender: AnyObject){
        guard let resetText = emailField.text else{return}
    
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
