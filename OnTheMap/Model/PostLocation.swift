//
//  PostLocation.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import Foundation

struct PostLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}
