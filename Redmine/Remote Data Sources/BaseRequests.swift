//
//  BaseRequests.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/4/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import Foundation
import Alamofire

class BaseRequests: NSObject {
    private static let url = "http://207.154.208.71"
    private static let apiKeyHeaderName = "X-Redmine-API-Key"
    
    class var headers: HTTPHeaders? {
        get {
            guard let apiKey = apiKey else {
                return nil
            }
            return [apiKeyHeaderName : apiKey]
        }
    }
    
    class var apiKey: String? {
        get {
            return UserDefaults.standard.string(forKey: "ApiKey")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ApiKey")
        }
    }
    
    class func url(uri: String)->String{
        return url + uri
    }
}
