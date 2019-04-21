//
//  SpotPagePostViewController.swift
//  Spot
//
//  Created by Sunjeev Gururangan on 4/21/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit

class SpotPagePostViewController: UIViewController {

    var spotID : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func createPost(_ sender: Any) {
        self.performSegue(withIdentifier: "postToCreatePost", sender: self )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(self.spotId)
        if segue.identifier == "postToCreatePost"{
            //if let destination = segue.destination as? UITabBarController,
            if let vc = segue.destination as? CreatePostViewController{
                vc.spotID = self.spotID
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
