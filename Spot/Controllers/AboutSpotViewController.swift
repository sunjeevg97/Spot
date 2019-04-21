//
//  AboutSpotViewController.swift
//  Spot
//
//  Created by Sunjeev Gururangan on 4/20/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
class AboutSpotViewController: UIViewController {

    var spotID : String?
    let db: Firestore! = Firestore.firestore()
    var imageURL : String?
    var spotImg : UIImage!
    
    @IBOutlet weak var spotImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        DispatchQueue.global().async{
            let dispatch = DispatchGroup()
            
            dispatch.enter()
            self.db.collection("spots").document(self.spotID!).getDocument { (snapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else{
                    
                    self.imageURL = snapshot?.get("image url") as? String
    
                }
                
                dispatch.leave()
                
            }
            
            dispatch.wait()
            print(self.imageURL)
            
            dispatch.wait()
            
            DispatchQueue.main.sync{
                //download image from Firebase Storage
               let gsReference = Storage.storage().reference(forURL: self.imageURL!)
                gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        print("error occured")
                    } else {
                        let image = UIImage(data: data!)
                        
                        self.spotImg = image
                        
                        self.spotImgView.image = self.spotImg
                    }
                }
                
            }
        }
        // Do any additional setup after loading the view.
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
