//
//  SignUpViewController.swift
//  Tinder-Clone
//
//  Created by Marquis Dennis on 12/11/15.
//  Copyright © 2015 FlashBolt. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class SignUpViewController: UIViewController {

    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var interestedInWomen: UISwitch!
    @IBAction func signUp(sender: AnyObject) {
        PFUser.currentUser()?["interestedInWomen"] = interestedInWomen.on
        PFUser.currentUser()?.saveInBackground()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get facebook details
        let graph = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, gender"])
        graph.startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(result)
                PFUser.currentUser()?["gender"] = result["gender"]
                PFUser.currentUser()?["name"] = result["name"]
                
                PFUser.currentUser()?.saveInBackground()
                
                let userId = result["id"] as! String
                
                //get facebook profile
                let facebookProfileURL = "https://graph.facebook.com/\(userId)/picture?type=large"
                
                if let fbURL = NSURL(string: facebookProfileURL) {
                    if let data = NSData(contentsOfURL: fbURL) {
                        self.profileImage.image = UIImage(data: data)
                        
                        let imageFile:PFFile = PFFile(data: data)!
                        
                        PFUser.currentUser()?["imageFile"] = imageFile
                        
                        PFUser.currentUser()?.saveInBackground()
                        
                    }
                }
            }
        }
    }
}
