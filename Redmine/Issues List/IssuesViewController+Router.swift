//
//  IssuesViewController+Router.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/7/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import UIKit

extension IssuesViewController: Router {
    
    enum Segue: String {
        case auth = "AuthSegue"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.auth.rawValue {
            guard segue.destination is AuthViewController else {
                print("wrong destination")
                return
            }
            // setup controller dependencies
            //controller.presenter = IssueListPresenter()
        }
    }
    
    func openAuth(){
        self.performSegue(withIdentifier: Segue.auth.rawValue, sender: nil)
    }
    
    func openIssue(_ issue: IssueData) {
        let viewController = IssueDetailsViewController()
        viewController.presenter = IssueDetailPresenter(issue: issue, delegate: self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
