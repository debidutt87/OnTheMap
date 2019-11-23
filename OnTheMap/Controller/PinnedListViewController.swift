//
//  PinnedListViewController.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import UIKit

class PinnedListViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    
    var studentLocArray = [StudentLocation]()
    
    override func viewDidLoad() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        refreshPinList()
        
    }
    
    @IBAction func refreshList(_ sender: Any) {
        refreshPinList()
    }
    
    @IBAction func addYourLocation(_ sender: Any) {
        
        let alertVC = UIAlertController(title: "Warning!", message: "You've already put your pin on the map.\nWould you like to overwrite it?", preferredStyle: .alert)
          
          alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [unowned self] (_) in
              self.performSegue(withIdentifier: "addLocation", sender: (true, self.studentLocArray))

          }))
          
          alertVC.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
          present(alertVC, animated: true, completion: nil)
    }
    
    @objc func refreshPinList() {
        //isDownloading(true)
        
        APIClient.getStudentLocation(completion:{ (data, error) in
          
        guard let data = data else {
            print(error?.localizedDescription ?? "")
            return
        }
        StudentsLocationData.studentsData = data
        self.studentLocArray.removeAll()
        self.studentLocArray.append(contentsOf: StudentsLocationData.studentsData.sorted(by: {$0.updatedAt > $1.updatedAt}))

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
            
        })
    }
}

extension PinnedListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        
        cell.textLabel?.text = studentLocArray[indexPath.row].firstName + " " + studentLocArray[indexPath.row].lastName
        cell.detailTextLabel?.text = studentLocArray[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        app.open(URL(string: studentLocArray[indexPath.row].mediaURL) ?? URL(string: "")!, options: [:], completionHandler: nil)
    }
    
}
