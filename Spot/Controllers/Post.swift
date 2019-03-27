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
    var photo:NSObject
    var uName: String
    var numLikes: Int
    
    init(captionText:String,photoObj:NSObject,uNameString:String, likesCount:Int){
        caption = captionText
        photo = photoObj
        uName = uNameString
        numLikes = likesCount
    }
}
