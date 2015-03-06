//
//  feedViewController.swift
//  Instagram
//
//  Created by Ronald Hernandez on 12/27/14.
//  Copyright (c) 2014 Wahoo. All rights reserved.
//

import UIKit

class feedViewController: UITableViewController {
    
    var titles = [String]()
    var usernames = [String]()
    var images = [UIImage]()
    var imageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var getFollwedUsersQuery = PFQuery(className: "followers")
        getFollwedUsersQuery.whereKey("follower", equalTo:PFUser.currentUser().username)
        getFollwedUsersQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                 var followedUser = ""
                
                for object in objects{
                   
                    
                   followedUser = object["following"] as String
                    
                    var query = PFQuery(className:"Post")
                    
                    query.whereKey("username", equalTo: followedUser)
                    
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            // The find succeeded.
                            NSLog("Successfully retrieved \(objects.count) images.")
                            // Do something with the found objects
                            for object in objects {
                                self.titles.append(object["Title"] as String)
                                self.usernames.append(object["username"] as String)
                                self.imageFiles.append(object["imageFile"] as PFFile)
                                
                                self.tableView.reloadData()
                                
                            }
                        } else {
                            // Log details of the failure
                            NSLog("Error: %@ %@", error, error.userInfo!)
                        }
                    }
                    
                    
                    
                }
                
                
            }
            
        }
    
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return titles.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 227
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var myCell:cell = self.tableView.dequeueReusableCellWithIdentifier("myCell") as cell
        
        myCell.title.text = titles[indexPath.row]
        myCell.username.text = usernames[indexPath.row]
        imageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData: NSData!, error: NSError!) -> Void in
          
            if error == nil{
                let image = UIImage(data: imageData)
                myCell.postedImage.image = image
            }
        }
        
        
        return myCell
    }

}
