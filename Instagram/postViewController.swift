//
//  postViewController.swift
//  Instagram
//
//  Created by Ronald Hernandez on 12/26/14.
//  Copyright (c) 2014 Wahoo. All rights reserved.
//

import UIKit

class postViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var shareText: UITextField!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
        
        
    }
    
    var photoSelected:Bool = false
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func chooseImage(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    @IBAction func postImage(sender: AnyObject) {
        var error = ""
        
        if photoSelected == false {
            
            error = "Please select an image to post"
            
        }else if (shareText.text == "") {
            
            error = "Please enter a message"
            
        }
        
        if (error != ""){
            
            displayAlert("Cannot Post Image!", error: error)
            
        }else {
            
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "Post")
            
            post["Title"] = shareText.text
            post["username"] = PFUser.currentUser().username
            
            post.saveInBackgroundWithBlock{(success: Bool!, error:NSError!) -> Void in
                if success == false {
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    self.displayAlert("Could Not Post Image", error: "Please Try Again")
                }else {
                    
                    let imageData = UIImagePNGRepresentation(self.imageToPost.image)
                    
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    post["imageFile"] = imageFile
                    
                    post.saveInBackgroundWithBlock{(success: Bool!, error:NSError!) -> Void in
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if success == false {
                            self.displayAlert("Could Not Post Image", error: "Please Try Again" )
                    
                        }else {
                            self.displayAlert("Image Posted!", error: "Your Message has been posted successfully" )
                            
                            self.photoSelected = false
                            self.imageToPost.image = UIImage(named: "placeholder.png")
                            self.shareText.text = ""
                            
                            println("posted successfully")
                        }
                
                    }
                }
            }
        }
    }
    
    
    
    
    func  imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        photoSelected = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoSelected = false
        imageToPost.image = UIImage(named: "placeholder.png")
        shareText.text = ""
        println(PFUser.currentUser())
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
