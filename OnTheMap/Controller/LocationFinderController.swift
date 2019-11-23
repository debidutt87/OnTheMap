//
//  LocationFinderController.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import UIKit
import MapKit

class LocationFinderController:UIViewController{
    
    @IBOutlet var enterLocation: UITextField!
    @IBOutlet var enterLink: UITextField!
    
    var updatePin: Bool!
    var mediaUrl: String = " "
    var studentArray: [StudentLocation]!
    
    override func viewDidLoad() {
        
    }
    
    
    @IBAction func findLocation(_ sender: Any) {
        
        guard let location = enterLocation.text else { return }

             
             if location == "" {
                 showAlert(title: "location doesn't exist", message: "Enter a valid location name")
        
             }
             else {
                 
                 guard let urlText = enterLink.text else { return }
                 guard urlText != "" else {
                     showAlert(title: "Link is empty", message: "You must provide a valid link.")
                     return
                 }
                 
                 mediaUrl = urlText.prefix(7).lowercased().contains("http://") || urlText.prefix(8).lowercased().contains("https://") ? urlText : "https://" + urlText
             }
        locator(location:location)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation" {
            let controller = segue.destination as! DropPinMapViewController
            let locationDetails = sender as!  (String, CLLocationCoordinate2D)
            controller.location = locationDetails.0
            controller.coordinate = locationDetails.1
            controller.updatePin = updatePin
            controller.studentLocArray = studentArray
            
            print("prepare URL: \(mediaUrl)")
            controller.url = mediaUrl
        }
    }
    
    
    func locator(location: String){
    
        CLGeocoder().geocodeAddressString(location) { (placemark, error) in
               
               guard error == nil else {
                   self.showAlert(title: "Error", message: "location not found: \(location)")
                   return
               }
               let coordinate = placemark?.first!.location!.coordinate
               
               print(coordinate?.latitude ?? 0)
               print(coordinate?.longitude ?? 0)
               
               self.performSegue(withIdentifier: "findLocation", sender: (location, coordinate))
           }
        
    }
}
