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
    let email: String = Auth.auth().currentUser?.email ?? "Invalid User"
    var nameGlobal : String = "";
    var usernameGlobal : String = "";
    var nametestGlobal : String?;
    var usertestGlobal : String?;
    var navigationBarAppearace = UINavigationBar.appearance()

    
    override func viewDidLoad() {
        
        nameGlobal = "test"
        usernameGlobal = "test"
        nametestGlobal = "test"
        usertestGlobal = "test"
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        runDispatch()
        
    }

    func runDispatch() {
        DispatchQueue.global().async {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            DispatchQueue.global().async {
                
                self.db.collection("users").document(self.id).getDocument { (snapshot, err) in
                    
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else{
                        self.nameGlobal = (snapshot?.get("name") as? String)!
                        self.usernameGlobal = (snapshot?.get("username") as? String)!
                        // Setting the title of the profile page to be the current user
                        self.title = self.usernameGlobal
                        //setting the color of the title to be white
                        self.navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                        //need to query list of user's friends and store them in a global variable
                    }
                    dispatchGroup.leave()
                    print("Did the first thing")
                }
            }
            dispatchGroup.wait()
            print("done waiting")
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
