//
//  ProfileViewController.swift
//  Spot
//
//  Created by Victoria Elaine Maxwell on 2/15/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProfileViewController: UIViewController {

    let db: Firestore! = Firestore.firestore()
    let id: String = Auth.auth().currentUser?.uid ?? "invalid ID"
    var nameGlobal : String = "";
    var usernameGlobal : String = "";
    
    override func viewDidLoad() {
        
        nameGlobal = "test"
        usernameGlobal = "test"
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //commented the logo to open space to enter the username field
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))

        setUserValues()
        
        print("global",nameGlobal)
        print("global",usernameGlobal)
        
        
        
        
        //commented out to figure out how to add user's name
        
        /* let display_name = UILabel(frame: CGRect(x: 150, y: 50, width: 298, height: 26))
        display_name.lineBreakMode = .byWordWrapping
        display_name.numberOfLines = 0
        display_name.textColor = UIColor.orange
        display_name.textAlignment = .center
        let display_Content = "NISH"
        let display_String = NSMutableAttributedString(string: display_Content, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 22)!
            ])
        let textRange = NSRange(location: 0, length: display_String.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.14
        display_String.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        display_name.attributedText = display_String
        display_name.sizeToFit()
        self.view.addSubview(display_name)
        */
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
