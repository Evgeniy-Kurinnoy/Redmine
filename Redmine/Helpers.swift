//
//  Helpers.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/7/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func from(_ string: String, format: String = "dd MMMM yyyy") -> Date?{
        return string.toDate(format: format)
    }
    
    func toString(format: String = "dd MMMM yyyy") -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
}

extension String {
    func toDate(format: String = "dd MMMM yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

func print(_ items: Any...){
    let string = "\(items.map { "\($0)" }.joined(separator: " "))"
    print("AARedmine \(string)", separator: " ")
}

extension UITextField {
    func shake(){
        self.frame = self.frame.offsetBy(dx: 5, dy: 0)

//        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .curveEaseInOut, .repeat], animations: {
//            self.frame = self.frame.offsetBy(dx: -10, dy: 0)
//        })
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [.curveEaseInOut, .autoreverse], animations: {
            self.frame = self.frame.offsetBy(dx: -10, dy: 0)

        }) { ok in
            self.frame = self.frame.offsetBy(dx: 5, dy: 0)
        }
    }
}

func onMain<T, U>(_ closure: @escaping (T, U)->Void) -> (T, U)->Void {
    return { t1, t2 in
        DispatchQueue.main.async {
            closure(t1, t2)
        }
    }
}


