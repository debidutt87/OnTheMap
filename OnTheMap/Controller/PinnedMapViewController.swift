//
//  PinnedMapViewController.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import UIKit
import MapKit

class PinnedMapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        self.mapView.delegate = self as? MKMapViewDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshMapView(animated)
    }
    
    @IBAction func refreshMapView(_ sender: Any) {
        
        APIClient.getStudentLocation(completion:{ (data, error) in
          
             guard let data = data else {
                 print(error?.localizedDescription ?? "")
                 return
             }
             DispatchQueue.main.async {
                StudentsLocationData.studentsData = data
                
                self.annotations.removeAll()
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                for val in StudentsLocationData.studentsData {
                 self.annotations.append(val.getMapAnnotation())
                }
                self.mapView.addAnnotations(self.annotations)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
            let destinationVC = segue.destination as? LocationFinderController
            let updateStudentInfo = sender as? (Bool, [StudentLocation])
            destinationVC?.updatePin = updateStudentInfo?.0
            destinationVC?.studentArray = updateStudentInfo?.1
        }
    }
    
    func alert(_ title: String, _ messageBody: String) {
        
        let alert = UIAlertController(title: title, message: messageBody, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension PinnedMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            guard let annotation = view.annotation else {
                return
            }
            guard var subtitle = annotation.subtitle else {
                return
            }
            if subtitle!.isValidURL {
                if subtitle!.starts(with: "www") {
                    subtitle! = "https://" + subtitle!
                }
                let url = URL(string: subtitle!)
                UIApplication.shared.open(url!)
            } else {
                
                alert("No URL", "There's no URL to open")
            }
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        _ = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
}
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

extension StudentLocation  {
    func getMapAnnotation() -> MKPointAnnotation {
        let mapAnnotation = MKPointAnnotation()
        mapAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        mapAnnotation.title = "\(firstName) \(lastName)"
        mapAnnotation.subtitle = "\(mediaURL)"
        
        return mapAnnotation
    }
}
