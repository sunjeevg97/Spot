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
    
    init(captionText:String,photoURLString:String){
        caption = captionText
        photoURL = photoURLString
    }
}
