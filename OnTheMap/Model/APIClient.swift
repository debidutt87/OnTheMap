//
//  APIClient.swift
//  OnTheMap
//
//  Created by Debidutt Prasad on 23/11/2019.
//  Copyright © 2019 bot consultancy. All rights reserved.
//

import Foundation

class APIClient{
    
    struct Auth {
        static var keyAccount = ""
        static var sessionId = ""
    
    }
    
    enum EndPoint {
        static let baseUrl = "https://onthemap-api.udacity.com/v1/"
        
        case getSessionId
        
        var urlString:String{
            switch self{
            case .getSessionId: return EndPoint.baseUrl + "session"
            }
        }
        
        var url: URL{
            return URL(string: urlString)!
        }
    }
    
    class func authenticate(email:String, password:String, completion: @escaping (Bool, Error?) -> ()){
        var request = URLRequest(url: EndPoint.getSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    return completion(false, error)
                }
                return
            }
            print("login: \(String(describing: String(data: data, encoding: .utf8)))")
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    self.Auth.sessionId = responseObject.session.id
                    self.Auth.keyAccount = responseObject.account.key
                    completion(true, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
}
