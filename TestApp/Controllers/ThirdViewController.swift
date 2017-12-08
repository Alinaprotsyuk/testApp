//
//  ThirdViewController.swift
//  TestApp
//
//  Created by Alina on 12/8/17.
//  Copyright © 2017 Alina. All rights reserved.
//

import UIKit
import GoogleSignIn

class ThirdViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print(user.profile.email)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        signInButton.center = self.view.center
        view.addSubview(signInButton)

        // Do any additional setup after loading the view.
    }

}
