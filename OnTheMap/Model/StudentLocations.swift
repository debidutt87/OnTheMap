//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import Foundation

struct StudentLocations: Codable {
    
    let results: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

class StudentsLocationData {
    
    static var studentsData = [StudentLocation]()
 
}
