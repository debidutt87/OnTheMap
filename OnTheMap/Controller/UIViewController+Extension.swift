//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {

        APIClient.deleteSession { (success: Bool, error: Error?) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }

            print(error?.localizedDescription ?? "")
        }
    }
    
    func showAlert(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

