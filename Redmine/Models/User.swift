//
//  User.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/4/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import Foundation

class User {
    let id: Int
    let login: String
    let firstName: String
    let lastName: String
    
    init?(json: [String: Any]?){
        guard let user = json?["user"] as? [String: Any] else { return nil }
        guard let id = user["id"] as? Int else { return nil }
        guard let login = user["login"] as? String else { return nil }
        guard let firstName = user["firstname"] as? String else { return nil }
        guard let lastName = user["lastname"] as? String else { return nil }
        guard let apiKey = user["api_key"] as? String else { return nil }
        
        self.id = id
        self.login = login
        self.firstName = firstName
        self.lastName = lastName
        
        BaseRequests.apiKey = apiKey
    }
}
