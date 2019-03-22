//
//  Post.swift
//  Spot
//
//  Created by Vatsal Parikh on 2/27/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import Foundation

class Post {
    var caption:String
    var photoURL:String
    var uName: String
    var numLikes: Int
    
    init(captionText:String,photoURLString:String,uNameString:String){
        caption = captionText
        photoURL = photoURLString
        uName = uNameString
        numLikes = 0
    }
}
