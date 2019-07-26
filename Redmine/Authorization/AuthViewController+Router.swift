//
//  Router.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/4/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import UIKit

protocol Router {

}

extension AuthViewController: Router {
    
    enum Segue: String {
        case issues = "IssuesSegue"
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Segue.issues.rawValue {
//            guard let controller = segue.destination as? IssuesViewController else {
//                print("wrong destination")
//                return
//            }
//            // setup controller dependencies
//            controller.presenter = IssueListPresenter()
//        }
//    }
    
    func openIssues(){
        //self.performSegue(withIdentifier: Segue.issues.rawValue, sender: nil)
        self.dismiss(animated: true)
        
    }
}
