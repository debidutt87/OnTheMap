//
//  PostLocationResponse.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import Foundation

struct PostLocationResponse: Codable {
    let createAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createAt
        case objectId
    }
}
