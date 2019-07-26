//
//  Repository.swift
//  test
//
//  Created by student-xCode on 7/1/19.
//  Copyright © 2019 student-xCode. All rights reserved.
//

import Foundation
import RxSwift

class IssueRepository {
    typealias IssuesPage = (offset: Int, limit: Int)
    
    public static let instance = IssueRepository()
    private let pageSize = 10
    
    private init(){}
    
    public func loadIssues(page: Int) -> Single<[IssueData]>{
        let offset = (page - 1) * pageSize
        return IssuesRequests.loadIssues(offset: offset, limit: pageSize)
    }
    
    public func getOffset(for page: Int) -> IssuesPage {
        let offset = (page - 1) * pageSize
        return IssuesPage(offset: offset, limit: pageSize)
    }
    
    public func page(of index: Int) -> Int {
        if index % pageSize == 0 {
            return index / pageSize
        } else {
            return (index / pageSize) + 1
        }
    }
}
