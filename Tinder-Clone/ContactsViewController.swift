//
//  ContactsViewController.swift
//  Tinder-Clone
//
//  Created by Marquis Dennis on 12/17/15.
//  Copyright © 2015 FlashBolt. All rights reserved.
//

import UIKit
import Parse

class ContactsViewController: UITableViewController {
    var emails = [String]()
    var userImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFUser.query()
        
        query?.whereKey("accepted", equalTo: PFUser.currentUser()!.objectId!)
        let acceptedList = (PFUser.currentUser()?["accepted"]) as! [String]
        query?.whereKey("objectId", containedIn: acceptedList)
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if let results = objects as! [PFUser]? {
                    for result in results {
                        self.emails.append(result.email!)
                        
                        let imageFile = result["image"] as! PFFile
                        imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                            if error != nil {
                                print (error)
                            } else if let data = data {
                                self.userImages.append(UIImage(data: data)!)
                                
                                self.tableView.reloadData()
                            }
                        })

                    }
                    
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = emails[indexPath.row]
        if userImages.count > indexPath.row {
            cell.imageView?.image = userImages[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = NSURL(string: "mailto:" + emails[indexPath.row])
        UIApplication.sharedApplication().openURL(url!)
        
    }

}
