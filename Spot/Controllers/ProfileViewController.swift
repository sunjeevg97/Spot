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
    var userHasImage = false

    private var childViewController: SpotsButtonViewController?
    @IBOutlet weak var ProfileIcon: UIImageView!
    
    
    @IBAction func onTapPhotomapButton(_ sender: Any) {
        childViewController?.reloadContent("Photomap")
    }
    
    @IBAction func onTapSpotsButton(_ sender: Any) {
        childViewController?.reloadContent("Spots")
    }
    
    
    @IBAction func onTapFriendsButton(_ sender: Any) {
        childViewController?.reloadContent("Friends")
    }
    
    override func viewDidLoad() {
        
        nameGlobal = "test"
        usernameGlobal = "test"
        nametestGlobal = "test"
        usertestGlobal = "test"
        
       //making the image circular
        ProfileIcon.layer.borderWidth = 1
        ProfileIcon.layer.masksToBounds = false
        ProfileIcon.layer.borderColor = UIColor.black.cgColor
        ProfileIcon.layer.cornerRadius = ProfileIcon.frame.height/2
        ProfileIcon.clipsToBounds = true
        //
    
        //Check if User has uploaded a picture, if not Displays Stock image
        if userHasImage == true {
            print("User's Profile")
        }
        else {
            ProfileIcon.image = UIImage(named: "Profile1x.png")
        }
        //end
        
        
        //
        
        
        super.viewDidLoad()

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
                        
                        
                        self.nameGlobal = (snapshot?.get("name") as! String)
                        self.usernameGlobal = (snapshot?.get("username") as! String)
                        
                        
                        
                        //setting the color of the title to be white
                          self.navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                        
                        
                        // Setting the title of the profile page to be the current user
                        self.title = self.usernameGlobal
                        
                        
                        
                        //Adding the Profile Name Underneath the Profile Icon
                        let profile_Name = UILabel(frame: CGRect(x: 131, y: 192, width: 201, height: 29))
                        profile_Name.lineBreakMode = .byWordWrapping
                        profile_Name.numberOfLines = 0
                        profile_Name.textColor = UIColor.white
                        profile_Name.textAlignment = .center
                        let profileContent = self.nameGlobal
                        let profileString = NSMutableAttributedString(string: profileContent, attributes: [
                            NSAttributedString.Key.font: UIFont(name: "Arial", size: 22)!
                            ])
                        let profileRange = NSRange(location: 0, length: profileString.length)
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 1.18
                        profileString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: profileRange)
                        profile_Name.attributedText = profileString
                        profile_Name.sizeToFit()
                        self.view.addSubview(profile_Name)
                        //
                      
                        
                        // load Place Name underneath the Profile Name
                        let currentLocationName = UILabel(frame: CGRect(x: 150, y: 220, width: 101, height: 18))
                        currentLocationName.lineBreakMode = .byWordWrapping
                        currentLocationName.numberOfLines = 0
                        currentLocationName.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
                        currentLocationName.textAlignment = .center
                        let currentLocationNameContent = "Chapel Hill, NC"
                        let currentLocationNameString = NSMutableAttributedString(string: currentLocationNameContent, attributes: [
                            NSAttributedString.Key.font: UIFont(name: "Arial", size: 11)!
                            ])
                        let currentLocationNameRange = NSRange(location: 0, length: currentLocationNameString.length)
                        let locationStyle = NSMutableParagraphStyle()
                        locationStyle.lineSpacing = 1.18
                        currentLocationNameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:locationStyle, range: currentLocationNameRange)
                        currentLocationName.attributedText = currentLocationNameString
                        currentLocationName.sizeToFit()
                        self.view.addSubview(currentLocationName)
                        
                        
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SpotsButtonViewController{
            self.childViewController = vc
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

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
