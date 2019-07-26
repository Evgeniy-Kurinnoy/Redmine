//
//  ViewController.swift
//  test
//
//  Created by student-xCode on 7/1/19.
//  Copyright © 2019 student-xCode. All rights reserved.
//

import UIKit
import RxSwift

class IssuesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: IssueListPresenter!
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    private var issueList: [IssueData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = IssueListPresenter()
        presenter.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (action) in
                switch action {
                case .updateIssues(let issues):
                    self.issueList = issues
                    self.tableView.reloadData()
                case .error(let error):
                    if error is NoAuthorize {
                        self.openAuth()
                    } else {
                        print(error)
                    }
                case .updating(let updating):
                    //show updating indicator
                    break
                }
            }).disposed(by: disposeBag)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //presenter.update(page: 1)
        tableView.reloadData()
    }
    
    private func indexPathsForUpdate(newIssues: [IssueData]) -> [IndexPath]{
        let indexesForUpdate = newIssues.enumerated().filter {
                if $0.offset >= issueList.count {
                    return true
                } else {
                    return $0.element != issueList[$0.offset]
                }
            }.map { $0.offset }
        print("last item index", issueList.count - 1)
        print("indexes for update", indexesForUpdate)

        return indexesForUpdate.map { IndexPath(item: $0, section: 0) }
    }
}

extension IssuesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IssueTableViewCell.reusableIdentifier) as? IssueTableViewCell ?? IssueTableViewCell()
        
        let issue = issueList[indexPath.row]
        cell.set(with: issue)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openIssue(issueList[indexPath.row])
    }
}

extension IssuesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetch rows at", indexPaths)

        if indexPaths.contains(IndexPath(item: issueList.count - 2, section: 0)) && presenter.hasNext {
            print("startPrefetch")
            presenter.getNextPage()
        }
    }
    
    
}

extension IssuesViewController: IssueChangeDelegate {
    func issueDidChange(newIssue: IssueData) {
        presenter.updateIssue(newIssue: newIssue)
    }
}
