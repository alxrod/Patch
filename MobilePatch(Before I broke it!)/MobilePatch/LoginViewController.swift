//
//  LoginViewController.swift
//  
//
//  Created by Antonio Rodriguez on 7/11/16.
//
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var failLabel: UILabel!
    @IBOutlet weak var loginProgress: UIActivityIndicatorView!
    
    
    
    
    /** this is called when the user clicks the Submit button */
    @IBAction func submitLogin(sender: UIButton) {
        NSLog("Here you go clicked to submit!")
        self.loginProgress.hidden = false
        self.failLabel.hidden = true
        self.loginProgress.startAnimating()
        getToken(usernameField.text!, password: passwordField.text!,
                 success: self.successfulLogin, failed: self.failedLogin)
    }
    
    func successfulLogin(token:String) {
        print("Success login!")
        print(token)
        self.loginProgress.stopAnimating()
        self.loginProgress.hidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.token = token
        appDelegate.showMainInterface()
        
        
    }
    
    func failedLogin() {
        print("Failed login")
        self.loginProgress.stopAnimating()
        self.loginProgress.hidden = true
        self.failLabel.hidden = false
        
    }
}


