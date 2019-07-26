//
//  IssueDetailsViewController.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/15/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

enum IssueEnumCell: CaseIterable {
    case title
    case message
    case project
    case status
    case priority
    case assignee
    case doneRatio
    case tracker
    case author
    case estimatedHours
    case startDate
    case dueDate
    case createdOn
    case updatedOn
}

fileprivate enum IssueCellTypes {
    case title
    case message
    case items
}

protocol IssueCellDelegate {
    func changeText(field: IssueEnumCell, value: String)
    func didEndChangeText(field: IssueEnumCell, value: String)
}

class IssueDetailsViewController: UIViewController {
    var presenter: IssueDetailPresenter!
    private var currentState: IssueDetailPresenter.State?
    private var issue: IssueData!

    private let tableView = UITableView()
    
    private let disposeBag = DisposeBag()
    
    private var editItem: UIBarButtonItem!
    private var doneItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        
        editItem = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(enableEditState))
        doneItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(disableEditState))
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        tableView.register(IssueDetailCell.self, forCellReuseIdentifier: IssueDetailCell.reuseIdentifier)
        tableView.register(IssueDetailsMessageCell.self, forCellReuseIdentifier: IssueDetailsMessageCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter.state
            .observeOn(MainScheduler.instance)
            .subscribe { event in
            switch event {
            case .next(let state):
                self.applyState(state)
            default:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    private func applyState(_ state: IssueDetailPresenter.State){
        currentState = state
        issue = state.issue
        self.title = issue.id.description

        if state.editing {
            self.navigationItem.rightBarButtonItem = doneItem
        } else {
            self.navigationItem.rightBarButtonItem = editItem
        }
        tableView.visibleCells.forEach {
            ($0 as? IssueDetailCell)?.editable = state.editing
            ($0 as? IssueDetailsMessageCell)?.editable = state.editing
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc private func enableEditState() {
        presenter.setEditing(editing: true)
    }

    @objc private func disableEditState() {
        presenter.setEditing(editing: false)
        presenter.saveChanges()
    }
    
}


extension IssueDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IssueEnumCell.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentRow = IssueEnumCell.allCases[indexPath.row]
        
        switch currentRow {
        case .title:
            let cell = getCell(for: .title)
            cell.textLabel?.text = issue.title
            return cell
            
        case .message:
            let cell = getCell(for: .message) as! IssueDetailsMessageCell
            cell.set(with: issue.description, type: .message)
            cell.delegate = self
            cell.editable = currentState?.editing
            return cell
            
        default:
            let cell = getCell(for: .items) as! IssueDetailCell
            cell.delegate = self
            cell.editable = currentState?.editing

            switch currentRow {
            case .project:
                cell.set(with: "Project", info: issue.project.name, type: currentRow)
                
            case .status:
                cell.set(with: "Status", info: issue.status.name, type: currentRow)
                
            case .priority:
                cell.set(with: "Priority", info: issue.priority.name, type: currentRow)

            case .assignee:
                cell.set(with: "Assignee", info: issue.assignedTo.name, type: currentRow)

            case .tracker:
                cell.set(with: "Tracker", info: issue.tracker.name, type: currentRow)

            case .author:
                cell.set(with: "Author", info: issue.author.name, type: currentRow)

            case .estimatedHours:
                cell.set(with: "Estimated hours", info: issue.estimatedHours.description, type: currentRow)
                
            case .startDate:
                cell.set(with: "Start date", info: issue.startDate.toString(format: "dd/MM/yyyy"), type: currentRow)

            case .dueDate:
                cell.set(with: "Due date", info: issue.dueDate.toString(format: "dd/MM/yyyy"), type: currentRow)

            case .createdOn:
                cell.set(with: "Created", info: issue.createdOn.toString(format: "dd/MM/yyyy"), type: currentRow)

            case .updatedOn:
                cell.set(with: "Updated", info: issue.updatedOn.toString(format: "dd/MM/yyyy"), type: currentRow)
                
            case .doneRatio:
                cell.set(with: "Done ratio", info: "\(issue.progress)%", type: currentRow)

            default: break

            }
            return cell
        }
    }
    
    private func getCell(for cellType: IssueCellTypes) -> UITableViewCell {
        switch cellType {
        case .title:
            return tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .default, reuseIdentifier: "default")

        case .message:
            return tableView.dequeueReusableCell(withIdentifier: IssueDetailsMessageCell.reuseIdentifier) ?? IssueDetailsMessageCell()
            
        case .items:
            return tableView.dequeueReusableCell(withIdentifier: IssueDetailCell.reuseIdentifier) ?? IssueDetailCell()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension IssueDetailsViewController: IssueCellDelegate {
    func changeText(field: IssueEnumCell, value: String) {
        print("new text", value)
        presenter.updateField(field: field, value: value)
    }
    
    func didEndChangeText(field: IssueEnumCell, value: String) {
        print("end editing", value)
        presenter.updateField(field: field, value: value)
    }
    
    
}
