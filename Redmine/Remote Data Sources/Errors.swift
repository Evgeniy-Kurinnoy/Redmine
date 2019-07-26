//
//  Errors.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/4/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import Foundation

class LError: LocalizedError {
    var errorMessage: String {
        get {
            fatalError("Subclasses need to implement the `errorMessage` property.")
        }
    }
    
    private let additionMessage: String?
    
    init(_ message: String? = nil) {
        self.additionMessage = message
    }
    
    var errorDescription: String? {
        get {
            if let addMessage = additionMessage {
                return errorMessage + ": " + addMessage
            } else {
                return errorMessage
            }
        }
    }
}

class ParseError: LError {
    override var errorMessage: String {
        get {
            return "required data not found"
        }
    }
}

class NoAuthorize: LError {
    override var errorMessage: String {
        get {
            return "need authorization"
        }
    }
}
