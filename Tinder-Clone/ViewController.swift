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
                    if let _ = user {
                        self.performSegueWithIdentifier("showSignInScreen", sender: self)
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
        /*PFUser.logOut();*/
        
        if let _ = PFUser.currentUser()?.username {
            performSegueWithIdentifier("showSignInScreen", sender: self)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

