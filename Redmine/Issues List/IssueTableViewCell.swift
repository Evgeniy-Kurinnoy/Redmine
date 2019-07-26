//
//  CustomTableViewCell.swift
//  test
//
//  Created by student-xCode on 7/1/19.
//  Copyright © 2019 student-xCode. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {
    static let reusableIdentifier = "issueCell"
    
    @IBOutlet weak var bugIcon: UIImageView!
    @IBOutlet weak var bugTitle: UILabel!
    @IBOutlet weak var bugDescription: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    public func set(with issue: IssueData){
        bugTitle.text = issue.title
        bugDescription.text = issue.description
        let progress = Float(issue.progress) / 100
        progressBar.setProgress(progress, animated: false)
        bugIcon.image = UIImage(named: "bug_icon")
    }

}
