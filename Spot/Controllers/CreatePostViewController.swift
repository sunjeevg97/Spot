//
//  CreatePostViewController.swift
//  Spot
//
//  Created by Vatsal Parikh on 4/7/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {

    override func viewDidLoad() {
        
        self.view.backgroundColor = .black
        
        super.viewDidLoad()

        //top rectangle with a gradient
        let topRectangle = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 87))
        let topRectangleGradient = CAGradientLayer()
        topRectangleGradient.frame = CGRect(x: 0, y: 0, width: 375, height: 87)
        topRectangleGradient.colors = [
            UIColor.black.cgColor,
            UIColor(red:0.17, green:0.17, blue:0.17, alpha:1).cgColor
        ]
        topRectangleGradient.locations = [0, 1]
        topRectangleGradient.startPoint = CGPoint(x: 0.5, y: 0.16)
        topRectangleGradient.endPoint = CGPoint(x: 0.5, y: 1.13)
        topRectangle.layer.addSublayer(topRectangleGradient)
        self.view.addSubview(topRectangle)
        
        
        //Cancel button
        let cancelBtn = UILabel(frame: CGRect(x: 12, y: 56, width: 186, height: 23))
        cancelBtn.lineBreakMode = .byWordWrapping
        cancelBtn.numberOfLines = 0
        cancelBtn.textColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1)
        let cancelBtnContent = "Cancel"
        let cancelBtnString = NSMutableAttributedString(string: cancelBtnContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let cancelBtnRange = NSRange(location: 0, length: cancelBtnString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.19
        cancelBtnString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: cancelBtnRange)
        cancelBtn.attributedText = cancelBtnString
        cancelBtn.sizeToFit()
        self.view.addSubview(cancelBtn)
        
        
        //Display name of Spot
        let spotName = UILabel(frame: CGRect(x: 120, y: 45, width: 325, height: 24))
        spotName.lineBreakMode = .byWordWrapping
        spotName.numberOfLines = 0
        spotName.textColor = UIColor.white
        spotName.textAlignment = .center
        let spotNameContent = "Caffe Driade"
        let spotNameString = NSMutableAttributedString(string: spotNameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 24)!
            ])
        let spotNameRange = NSRange(location: 0, length: spotNameString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        spotNameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: spotNameRange)
        spotNameString.addAttribute(NSAttributedString.Key.kern, value: 1.38, range: spotNameRange)
        spotName.attributedText = spotNameString
        spotName.sizeToFit()
        self.view.addSubview(spotName)
        
        
        //Display name of city
        let cityName = UILabel(frame: CGRect(x: 145, y: 69, width: 186, height: 15))
        cityName.lineBreakMode = .byWordWrapping
        cityName.numberOfLines = 0
        cityName.textColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1)
        cityName.textAlignment = .center
        let cityNameContent = "Chapel Hill, NC"
        let cityNameString = NSMutableAttributedString(string: cityNameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!
            ])
        let cityNameRange = NSRange(location: 0, length: cityNameString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        cityNameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: cityNameRange)
        cityName.attributedText = cityNameString
        cityName.sizeToFit()
        self.view.addSubview(cityName)
        
        //Post button
        let postBtn = UIView(frame: CGRect(x: 312, y: 54, width: 51, height: 24))
        postBtn.layer.cornerRadius = 12
        postBtn.backgroundColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        postBtn.layer.borderWidth = 2.4
        postBtn.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        self.view.addSubview(postBtn)
        
        //Caption text field
        let captionInput = UITextField(frame: CGRect(x: 40, y: 200, width: 300, height: 300))
        captionInput.textColor = UIColor.white
        captionInput.placeholder = "write caption here"
        captionInput.backgroundColor = UIColor.gray
        
        self.view.addSubview(captionInput)
        
        //camera button
        let cameraFrame = UIImageView(frame: CGRect(x: 13, y: 406, width: 84, height: 48))
        cameraFrame.image = UIImage(named: "AddPostCamera.png")
        cameraFrame.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.addSubview(cameraFrame)
        
        //Gallery image
        let galleryFrame = UIImageView(frame: CGRect(x: 13, y: 463, width: 84, height: 48))
        galleryFrame.image = UIImage(named: "AddPostPhotoLibrary.png")
        galleryFrame.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.addSubview(galleryFrame)
        
        
    }
    

    

}
