//
//  IssuesRequests.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/7/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class IssuesRequests: BaseRequests {
    typealias IssuesResponse = ([IssueData], Error?)->Void
    
    class func loadIssues(offset: Int? = nil, limit: Int? = nil, _ completion: @escaping IssuesResponse) -> DataRequest?{
        guard let headers = self.headers else {
            completion([], NoAuthorize())
            return nil
        }
        
        var params: [String: Any] = [:]
        if let limit = limit {
            params["limit"] = limit
        }
        if let offset = offset {
            params["offset"] = offset
        }
        
         return request(url(uri: "/issues.json"), method: .get, parameters: params, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
               // print(json)
                if let json = json as? [String: Any],
                let issues = json["issues"] as? [[String: Any]] {
                    
                    let result = issues.map { IssueData(from: $0) }
                        .filter { $0 != nil }
                        .map { $0! }
                    completion(result, nil)
                    
                } else {
                    completion([], NoAuthorize())
                }
            case .failure(let error):
                completion([], error)
            }
        }
    }
    
    class func loadIssues(offset: Int? = nil, limit: Int? = nil)->Single<[IssueData]>{
        return Single.create(subscribe: { (event) -> Disposable in
            
            let request = loadIssues(offset: offset, limit: limit, { (issues, error) in
                if let err = error {
                    event(.error(err))
                } else {
                    event(.success(issues))
                }
            })
            
            return Disposables.create {
                request?.cancel()
            }
        })
    }
    
    class func updateIssue(issue: IssueData, _ completion: @escaping (Bool, Error?) -> Void){
        guard let headers = self.headers else {
            return
        }
        
        let params = issue.toJson()
        
        request(url(uri: "/issues/\(issue.id).json"), method: .put, parameters: params, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success( _):
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
}
