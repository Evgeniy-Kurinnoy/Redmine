//
//  Presenter.swift
//  test
//
//  Created by student-xCode on 7/1/19.
//  Copyright © 2019 student-xCode. All rights reserved.
//

import Foundation
import RxSwift

class IssueListPresenter {
    private let repository = IssueRepository.instance
    
    enum Action {
        case updateIssues([IssueData])
        case error(Error)
        case updating(Bool)
    }
    
    private let stateSubject = BehaviorSubject<Action>(value: .updateIssues([]))
    public var state: Observable<Action> {
        return stateSubject.asObserver()
    }
    
    private var disposable: Disposable?
    
    private var currentPage: Int = 1
    private var issuesCache: [IssueData] = []
    private var loading: Bool = false {
        didSet {
            stateSubject.on(.next(.updating(loading)))
        }
    }
    private(set) var hasNext = true
    
    init() {
        getNextPage()
    }
    
    func getNextPage(){
        update(page: currentPage)
    }
 
    func update(page: Int){
        if loading {
            return
        }
        print("load new page")

        loading = true
        
        disposable?.dispose()
        disposable = repository.loadIssues(page: page)
            .do(onSuccess: {
                if $0.isEmpty {
                    self.hasNext = false
                }
            })
            .subscribe { event in
                self.loading = false
                switch event {
                case .success(let issues):
                    let offset = self.repository.getOffset(for: page)
                    let range = offset.offset..<(offset.limit + offset.offset)
                    if range.startIndex < self.issuesCache.count
                        && range.endIndex < self.issuesCache.count {
                        self.issuesCache.replaceSubrange(range, with: issues)
                    } else {
                        self.currentPage += 1
                        self.issuesCache.append(contentsOf: issues)
                    }
                    self.stateSubject.on(.next(.updateIssues(self.issuesCache)))
                    
                case .error(let error):
                    self.stateSubject.on(.next(.error(error)))
                }
        }
    }
    
    func page(of index: Int) -> Int{
        return repository.page(of: index)
    }
    
    func updateIssue(newIssue: IssueData){
        issuesCache = issuesCache.map {
            if $0.id == newIssue.id {
                return newIssue
            } else {
                return $0
            }
        }
        self.stateSubject.onNext(.updateIssues(issuesCache))
    }
}
