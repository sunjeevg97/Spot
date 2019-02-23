//
//  FeedViewController.swift
//  Spot
//
//  Created by Victoria Elaine Maxwell on 2/15/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self

        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo1x.png"))
    }
    

   

}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        
//        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.gray
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
        
    }
    
    
    
    
}

