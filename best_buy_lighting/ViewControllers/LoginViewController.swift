//
//  ViewController.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/21/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, LogInSuccessDelegate{

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
//        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.signInSilently()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loginDelegate = self
    }
    
    
    func logInSuccessful() {
        print("segue to products list")
        performSegue(withIdentifier: "ProductListViewControllerSegue", sender: self)
    }
}


