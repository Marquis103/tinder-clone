//
//  SwipingViewController.swift
//  Tinder-Clone
//
//  Created by Marquis Dennis on 12/16/15.
//  Copyright © 2015 FlashBolt. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    var displayedUserId = ""
    
    var startingPoint : CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pan = UIPanGestureRecognizer(target: self, action: "wasDragged:")
        userImage.addGestureRecognizer(pan)
        userImage.userInteractionEnabled = true
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if let geopoint = geopoint {
                    PFUser.currentUser()?["location"] = geopoint
                    PFUser.currentUser()?.saveInBackground()
                }
            }
        }
        
        getNextUserImage()
    }
    
    func getNextUserImage() {
        let query = PFUser.query()
        
        if let latitude = PFUser.currentUser()?["location"]?.latitude, let longitude = PFUser.currentUser()?["location"]?.longitude {
                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: longitude + 1))
                                                                                                                                                                                                                                                                 
        }
        
        var interestedIn = "male"
        
        if (PFUser.currentUser()?["interestedInWomen"])! as! Bool == true {
            interestedIn = "female"
        }
        
        var isFemale = true
        
        if (PFUser.currentUser()?["gender"])! as! String == "male" {
            isFemale = false
        }
        
        query?.whereKey("gender", equalTo: interestedIn)
        query?.whereKey("interestedInWomen", equalTo: isFemale)
        
        //can't do not contained in on multiple arrays of objectid
        var ignoredUsers = [String]()
        if let acceptedUsers = PFUser.currentUser()?["accepted"] {
            ignoredUsers += acceptedUsers as! Array

        }
        if let rejectedUsers = PFUser.currentUser()?["rejected"] {
            ignoredUsers += rejectedUsers as! Array
            
        }
        
        if ignoredUsers.count > 0 {
            query?.whereKey("objectId", notContainedIn: ignoredUsers)   
        }
        
        query?.limit = 1
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error != nil {
                print(error)
            } else if let objects = objects {
                for object in objects {
                    self.displayedUserId = object.objectId!
                    
                    let imageFile = object["image"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                        if error != nil {
                            print (error)
                        } else if let data = data {
                            self.userImage.image = UIImage(data: data)
                        }
                    })
                }
            }
        })
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        let label = gesture.view!
        if gesture.state == UIGestureRecognizerState.Began {
            startingPoint = label.center
        }
        
        var acceptedOrRejected = ""
        
        //how much object has moved away from it's original center
        let translation = gesture.translationInView(self.view)
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        let scale = min(100 / abs(xFromCenter), 1)
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        label.transform = stretch
        
        label.center = CGPoint(x: startingPoint.x + translation.x, y: startingPoint.y + translation.y)
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if label.center.x < 100 {
                acceptedOrRejected = "rejected"
            } else if label.center.x > self.view.bounds.width - 100 {
                acceptedOrRejected = "accepted"
            }
            
            if acceptedOrRejected != "" {
                PFUser.currentUser()?.addUniqueObjectsFromArray([displayedUserId], forKey: acceptedOrRejected)
                PFUser.currentUser()?.saveInBackground()
            }
            
            
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            label.transform = stretch
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            getNextUserImage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logOut" {
            PFUser.logOut()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        /*if segue.identifier == "logOut" {
            PFUser.logOut()
        }*/
    }

}
