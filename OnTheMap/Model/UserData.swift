//
//  UserData.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import Foundation

struct UserData: Codable {
    let firstName: String
    let lastName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
