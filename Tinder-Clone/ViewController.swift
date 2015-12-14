//
//  ViewController.swift
//  Tinder-Clone
//
//  Created by Marquis Dennis on 12/9/15.
//  Copyright © 2015 FlashBolt. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4


class ViewController: UIViewController {
    
    @IBAction func signIn(sender: AnyObject) {
        let permissions = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user, error) -> Void in
                if let error = error {
                    print(error)
                } else {
                    if let user = user {
                        if let _ = user["interestedInWomen"] {
                            self.performSegueWithIdentifier("logUserIn", sender: self)
                        } else {
                            self.performSegueWithIdentifier("showSignInScreen", sender: self)
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let push = PFPush()
        push.setChannel("Giants")
        push.setMessage("The Giants just scored!")
        push.sendPushInBackground()*/
        
        
    }

    override func viewDidAppear(animated: Bool) {
        if let _ = PFUser.currentUser()?.username {
            if let _ = PFUser.currentUser()?["interestedInWomen"] {
                performSegueWithIdentifier("logUserIn", sender: self)
            } else {
                performSegueWithIdentifier("showSignInScreen", sender: self)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

