//
//  ViewController.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/4/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import UIKit


class AuthViewController: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if BaseRequests.apiKey != nil {
            openIssues()
        }

    }
    
    private func isValidFields()->Bool{
        var valid = true
        if loginField.text?.count ?? 0 < 6 {
            valid = false
            loginField.shake()
        }
        
        if passwordField.text?.count ?? 0 < 6 {
            valid = false
            passwordField.shake()
        }
        
        return valid
    }

    @IBAction func signInAction(_ sender: Any) {
        if !isValidFields() { return }
        guard let login = loginField.text, let password = passwordField.text else { return }
        AuthorizationRequests
            .login(login: login, password: password, onMain { (user, error) in
                if let _ = user {
                    self.openIssues()
                } else {
                    print(error.debugDescription)
                }
        })
    }
    
}

