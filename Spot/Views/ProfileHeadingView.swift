//
//  ProfileHeadingView.swift
//  Spot
//
//  Created by nishit on 3/25/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit

@IBDesignable class ProfileHeadingView: UIView {
    
    @IBOutlet weak var userProfileIcon: UIImageView!
    @IBOutlet weak var userBio: UITextView!

    var view:UIView!
    
    @IBInspectable var userCustomImage:UIImage? {
        get {
            return userProfileIcon.image
        }
        set(userCustomImage) {
            userProfileIcon.image = userCustomImage
        }
        
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
//        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeightaddSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "ProfileHeadingView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    
    
}


/*
 var view:UIView!
 
 @IBInspectable
 var mytitleLabelText: String? {
 get {
 return titleLabel.text
 }
 set(mytitleLabelText) {
 titleLabel.text = mytitleLabelText
 }
 }
 
 @IBInspectable
 var myCustomImage:UIImage? {
 get {
 return myImage.image
 }
 set(myCustomImage) {
 myImage.image = myCustomImage
 }
 }
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 setup()
 }
 
 required init(coder aDecoder: NSCoder) {
 super.init(coder: aDecoder)
 setup()
 }
 
 func setup() {
 view = loadViewFromNib()
 view.frame = bounds
 view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeightaddSubview(view)
 }
 
 func loadViewFromNib() -> UIView {
 let bundle = NSBundle(forClass:self.dynamicType)
 let nib = UINib(nibName: “MyCustomView”, bundle: bundle)
 let view = nib.instantiateWithOwner(self, options: nil)[0] as UIView
 
 return view
 }
 }
 */
