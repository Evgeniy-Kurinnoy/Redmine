//
//  IssueDetailsPresenter.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/18/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import Foundation
import RxSwift

protocol IssueChangeDelegate {
    func issueDidChange(newIssue: IssueData)
}

class IssueDetailPresenter {
    struct State {
        var issue: IssueData
        var editing: Bool
    }
    
    private var originalIssue: IssueData
    private var issueTemp: IssueData
    
    private let delegate: IssueChangeDelegate
    
    private let stateSubject: BehaviorSubject<State>
    private var currentState: State
    
    var state: Observable<State> {
        return stateSubject.asObservable()
    }
    
    init(issue: IssueData, delegate: IssueChangeDelegate){
        originalIssue = issue
        issueTemp = issue//IssueData(with: issue)
        self.delegate = delegate
        currentState = State(issue: issueTemp, editing: false)
        stateSubject = BehaviorSubject<State>(value: currentState)
    }
    
    func updateField(field: IssueEnumCell, value: String){
        switch field {
        case .message:
            issueTemp.description = value

        default: break
        }
        currentState.issue = issueTemp
        stateSubject.onNext(currentState)
    }
    
    func setEditing(editing: Bool){
        currentState.editing = editing
        stateSubject.onNext(currentState)
    }
    
    func saveChanges(){
        IssuesRequests.updateIssue(issue: originalIssue) { [weak self] ok, error in
            guard let context = self else { return }
            context.originalIssue = context.issueTemp
            context.delegate.issueDidChange(newIssue: context.issueTemp)
        }
    }
}

