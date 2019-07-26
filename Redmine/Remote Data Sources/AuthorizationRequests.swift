//
//  AuthorizationRequests.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/4/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import Foundation
import Alamofire

class AuthorizationRequests : BaseRequests {
    
    class func login(login: String, password: String, _ completion: @escaping (User?, Error?)->Void){
        request(url(uri: "/users/current.json")).authenticate(user: login, password: password).validate().responseJSON { (response) in
            switch response.result {
            case .success(let resultJson):
                if let user = User(json: resultJson as? [String: Any]) {
                    completion(user, nil)
                } else {
                    completion(nil, ParseError("user not found"))
                }
                break
            case .failure(let error):
                completion(nil, error)
                break
            }
        }
        
    }
}
