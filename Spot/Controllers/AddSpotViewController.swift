//
//  AddSpotViewController.swift
//  Spot
//
//  Created by Sunjeev Gururangan on 2/24/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase

class AddSpotViewController: UIViewController {
    
    var spotNameTextField : UITextField!
    var descriptionTextField: UITextField!
    var directionsTextField: UITextField!
    
    var spotPic: UIImageView!
    var addSpotBtn : UIButton!
    
    let imgPicker = UIImagePickerController()
    
    var tag1TextField: UITextField!
    var tag2TextField: UITextField!
    var tag3TextField: UITextField!
    
    var submitBtn : UIButton!
    
    var urlStr : String = " "
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        imgPicker.delegate = self
        //name label
        let nameLabel = UILabel(frame: CGRect(x: 16, y: 109, width: 171, height: 16))
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        nameLabel.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let textContent = "SPOT NAME"
        let textString = NSMutableAttributedString(string: textContent, attributes: [    NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.13
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 1, range: textRange)
        nameLabel.attributedText = textString
        nameLabel.sizeToFit()
        self.view.addSubview(nameLabel)
        
        //Name textfield
        spotNameTextField = UITextField(frame: CGRect(x: 16, y: 130, width: 253, height: 32))
        spotNameTextField.layer.cornerRadius = 5
        spotNameTextField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        spotNameTextField.layer.borderWidth = 0.75
        spotNameTextField.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        spotNameTextField.textColor = UIColor.white
        view.addSubview(spotNameTextField)
        
        /********* PICTURE ******/
        //picture label
        let textLayer1 = UILabel(frame: CGRect(x: 16, y: 184, width: 171, height: 16))
        textLayer1.lineBreakMode = .byWordWrapping
        textLayer1.numberOfLines = 0
        textLayer1.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let textContent1 = "PICTURES"
        let textString1 = NSMutableAttributedString(string: textContent1, attributes: [    NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!])
        let textRange1 = NSRange(location: 0, length: textString1.length)
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 1.13
        textString1.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle1, range: textRange1)
        textString1.addAttribute(NSAttributedString.Key.kern, value: 1, range: textRange1)
        textLayer1.attributedText = textString1
        textLayer1.sizeToFit()
        self.view.addSubview(textLayer1)
        
        //picture input
        spotPic = UIImageView(frame: CGRect(x: 16, y: 208, width: 111, height: 131))
        spotPic.layer.cornerRadius = 5
        spotPic.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        spotPic.layer.borderWidth = 0.75
        spotPic.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        self.view.addSubview(spotPic)
        
        //load image button
        addSpotBtn = UIButton(frame: CGRect(x: 200, y: 271, width: 70, height: 50))
        addSpotBtn.backgroundColor = UIColor.green
        addSpotBtn.setTitle("pick", for: .normal)
        addSpotBtn.addTarget(self, action: #selector(openCamRoll), for: .touchUpInside)
        self.view.addSubview(addSpotBtn)
        
        /********* DESCRIPTION ******/
        //Description label
        let textLayer2 = UILabel(frame: CGRect(x: 16, y: 364, width: 171, height: 16))
        textLayer2.lineBreakMode = .byWordWrapping
        textLayer2.numberOfLines = 0
        textLayer2.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let textContent2 = "DESCRIPTION"
        let textString2 = NSMutableAttributedString(string: textContent2, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let textRange2 = NSRange(location: 0, length: textString2.length)
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineSpacing = 1.13
        textString2.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle2, range: textRange2)
        textString2.addAttribute(NSAttributedString.Key.kern, value: 1, range: textRange2)
        textLayer2.attributedText = textString2
        textLayer2.sizeToFit()
        self.view.addSubview(textLayer2)
        
        //Description textfield
        descriptionTextField = UITextField(frame: CGRect(x: 16, y: 385, width: 343, height: 58))
        descriptionTextField.layer.cornerRadius = 5
        descriptionTextField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        descriptionTextField.layer.borderWidth = 0.75
        descriptionTextField.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        descriptionTextField.textColor = UIColor.white
        self.view.addSubview(descriptionTextField)
        
        /********* WALKING DIRECTIONS ******/
        //walking direction label
        let textLayer3 = UILabel(frame: CGRect(x: 16, y: 469, width: 297, height: 16))
        textLayer3.lineBreakMode = .byWordWrapping
        textLayer3.numberOfLines = 0
        textLayer3.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let textContent3 = "WALKING DIRECTIONS"
        let textString3 = NSMutableAttributedString(string: textContent3, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let textRange3 = NSRange(location: 0, length: textString3.length)
        let paragraphStyle3 = NSMutableParagraphStyle()
        paragraphStyle3.lineSpacing = 1.13
        textString3.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle3, range: textRange3)
        textString3.addAttribute(NSAttributedString.Key.kern, value: 1, range: textRange3)
        textLayer3.attributedText = textString3
        textLayer3.sizeToFit()
        self.view.addSubview(textLayer3)
        
        //walking directions
        directionsTextField = UITextField(frame: CGRect(x: 16, y: 490, width: 343, height: 58))
        directionsTextField.layer.cornerRadius = 5
        directionsTextField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        directionsTextField.layer.borderWidth = 0.75
        directionsTextField.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        directionsTextField.textColor = UIColor.white
        self.view.addSubview(directionsTextField)
        
        
        //tag label
        let textLayer4 = UILabel(frame: CGRect(x: 16, y: 574, width: 48, height: 16))
        textLayer4.lineBreakMode = .byWordWrapping
        textLayer4.numberOfLines = 0
        textLayer4.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let textContent4 = "TAGS"
        let textString4 = NSMutableAttributedString(string: textContent4, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let textRange4 = NSRange(location: 0, length: textString4.length)
        let paragraphStyle4 = NSMutableParagraphStyle()
        paragraphStyle4.lineSpacing = 1.13
        textString4.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle4, range: textRange4)
        textString4.addAttribute(NSAttributedString.Key.kern, value: 1, range: textRange4)
        textLayer4.attributedText = textString4
        textLayer4.sizeToFit()
        self.view.addSubview(textLayer4)
        
        
        //tag 1
        tag1TextField = UITextField(frame: CGRect(x: 16, y: 595, width: 90, height: 28))
        tag1TextField.layer.cornerRadius = 5
        tag1TextField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        tag1TextField.layer.borderWidth = 0.75
        tag1TextField.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        tag1TextField.textColor = UIColor.white
        self.view.addSubview(tag1TextField)
        
        //tag 2
        tag2TextField = UITextField(frame: CGRect(x: 120, y: 595, width: 89, height: 28))
        tag2TextField.layer.cornerRadius = 5
        tag2TextField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        tag2TextField.layer.borderWidth = 0.75
        tag2TextField.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        tag2TextField.textColor = UIColor.white
        self.view.addSubview(tag2TextField)
        
        //tag 3
        tag3TextField = UITextField(frame: CGRect(x: 223, y: 594, width: 90, height: 28))
        tag3TextField.layer.cornerRadius = 5
        tag3TextField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        tag3TextField.layer.borderWidth = 0.75
        tag3TextField.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        tag3TextField.textColor = UIColor.white
        self.view.addSubview(tag3TextField)
        
        //PRIVACY SETTINGS -- need image
        //public Spot
    
        //Submit button
        let sBtnLayer = UILabel(frame: CGRect(x: 292.81, y: 671.11, width: 62.58, height: 17.78))
        sBtnLayer.lineBreakMode = .byWordWrapping
        sBtnLayer.numberOfLines = 0
        sBtnLayer.textColor = UIColor.white
        sBtnLayer.textAlignment = .center
        let sBtnTextContent = "SUBMIT"
        let sBtnTextString = NSMutableAttributedString(string: sBtnTextContent, attributes: [    NSAttributedString.Key.font: UIFont(name: "Arial", size: 16.8)!])
        let sBtnTextRange = NSRange(location: 0, length: sBtnTextString.length)
        let sBtnParagraphStyle = NSMutableParagraphStyle()
        sBtnParagraphStyle.lineSpacing = 1.13
        sBtnTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value:sBtnParagraphStyle, range: sBtnTextRange)
        sBtnTextString.addAttribute(NSAttributedString.Key.kern, value: 0.5, range: sBtnTextRange)
        sBtnLayer.attributedText = sBtnTextString
        sBtnLayer.sizeToFit()
        self.view.addSubview(sBtnLayer)
        
        
        //DispatchQueue.main.async {
            
            self.submitBtn = UIButton(frame: CGRect(x: 288, y: 664, width: 71, height: 32))
            self.submitBtn.layer.cornerRadius = 9.6
            self.submitBtn.backgroundColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
            self.submitBtn.layer.borderWidth = 2.4
            self.submitBtn.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
            self.submitBtn.addTarget(self, action: #selector(self.handleAddSpot), for: .touchUpInside)
            self.view.addSubview(self.submitBtn)
            
        //}
        
        // Do any additional setup after loading the view.
        
    }
    
    @objc func openCamRoll(_sender: AnyObject){
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        present(imgPicker, animated: true, completion: nil)
    }
    
    @objc func handleAddSpot(_sender: AnyObject){
        let db = Firestore.firestore()
        let uuid = UUID().uuidString
        
        guard let userId = Auth.auth().currentUser?.uid else{return}
        
        guard let name = spotNameTextField.text as String? else{return}
        guard let description = descriptionTextField.text as String? else{return}
        guard let directions = directionsTextField.text as String? else{return}
        guard let tag1 = tag1TextField.text as String? else{return}
        guard let tag2 = tag2TextField.text as String? else{return}
        guard let tag3 = tag3TextField.text as String? else{return}

        
        let values = ["spot name" : name,
                      "description" : description,
                      "directions" : directions,
                      "tag1": tag1,
                      "tag2": tag2,
                      "tag3": tag3,
                      "created by": userId]
        
        
        
        guard let image = spotPic.image else {return}
        //1. Upload Image to Firebase Storage
        self.uploadSpotImage(image){error in
            
            if error == nil{
                print("imaged saved to db")
            }
        }
        
        //2. Upload Image URL and Other Spot Data and Firebase Firestore
        
         db.collection("spots").document(uuid).setData(values, merge: true)
        
    }
    
    
    func uploadSpotImage(_ image:UIImage, completion: @escaping ((_ url:String?) -> ())){
        
        
            let uuid = UUID().uuidString
            let storageRef = Storage.storage().reference().child("spotPics-dev").child("\(uuid)")
            guard let imageData = image.jpegData(compressionQuality: 0.75) else{return}
        
            var urlStr: String = ""
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
        
        
        
            storageRef.putData(imageData, metadata: metadata){metadata, error in
                if error == nil, metadata != nil{
                    //get download url
                    
                    //dispatchgroup.enter()
                    
                    storageRef.downloadURL(completion: { url, error in
                        if let error = error{
                            print("\(error.localizedDescription)")
                            
                            //dispatchgroup.leave()
                        }
                            //url
                            urlStr = (url?.absoluteString)!
                            print(urlStr)
                        
                            //dispatchgroup.leave()
                        
                        })
                    
                        //dispatchgroup.wait()
                       // print(urlStr)
                    
                }else{
                    completion(nil)
                }
            }
        }
    
    
        
        
    }
    
    


extension AddSpotViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker : UIImage?
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = image
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImageFromPicker = image
        }
        
        if let selectedImage = selectedImageFromPicker{
            spotPic.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
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





