//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:UIViewController{
    
    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func initiateLogin(_ sender: Any) {
        print("emailAddress: \(String(describing: emailAddress.text))")
        print("password: \(String(describing: password.text))")
        
        APIClient.authenticate(email: emailAddress.text!, password: password.text!, completion: responseHandler(status:error:))
        
    }
    
    @IBAction func initiateSignUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    func responseHandler(status: Bool,error: Error?){
        if status {
            print("navigating to map view")
            performSegue(withIdentifier: "authenticationComplete", sender: nil)
        }else{
            print("authentication failure : staying on login page")
            
            let alertVC = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Email ID or Password is incorrect", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            show(alertVC, sender: nil)
        }
    }
    
}
