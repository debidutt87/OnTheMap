//
//  DropPinMapViewController.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import UIKit
import MapKit

class DropPinMapViewController: UIViewController{
    
    @IBOutlet var mapView: MKMapView!
    
    var location: String!
    var coordinate: CLLocationCoordinate2D!
    var updatePin: Bool!
    var url: String!
    var studentLocArray: [StudentLocation]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self as? MKMapViewDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard coordinate != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        addLocation(coordinate: coordinate)
    }
        
    @IBAction func tappedFinish(_ sender: Any) {
            
            // get User data : firstName, lastName
            APIClient.getUserData { (userData, error) in
                guard let userData = userData else {
                    self.showAlert(title: "Warning!", message: error?.localizedDescription ?? "")
                    return
                }
         
                let studentLocationRequest = PostLocation(uniqueKey: userData.key, firstName: userData.firstName, lastName: userData.lastName, mapString: self.location, mediaURL: self.url, latitude: Float(self.coordinate.latitude), longitude: Float(self.coordinate.longitude))
                
                
                // network request
                self.updatePin ? self.updateExistedSpot(postLocationData: studentLocationRequest) : self.postSpot(postLocationData: studentLocationRequest)
            }

        }
        
        
        func postSpot(postLocationData: PostLocation) {
            APIClient.postStudentLoaction(postLocation: postLocationData) { (success,error) in
                if error != nil{
                    self.showAlert(title: "can't post new pin", message: "Error message :\n\(error?.localizedDescription ?? "can't post")")
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                    
            }
        }

        func updateExistedSpot(postLocationData: PostLocation) {
            if studentLocArray.isEmpty { return }
            // put student location
            APIClient.putStudentLocation(objectID: studentLocArray[0].objectID, postLocation: postLocationData) { (success, error) in
                
                if error  != nil{
                    self.showAlert(title: "can't post new pin", message: "Error message :\n\(error?.localizedDescription ?? "can't post")")
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
        
            }
        }
        
}
extension DropPinMapViewController: MKMapViewDelegate {
        
        func addLocation(coordinate: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location
            
            let mapRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(mapRegion, animated: true)
                self.mapView.regionThatFits(mapRegion)
            }
        }
        
    }
    
    
    

