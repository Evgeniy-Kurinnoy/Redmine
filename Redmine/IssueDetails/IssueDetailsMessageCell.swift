//
//  IssueDetailsMessageCell.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/15/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import UIKit
import SnapKit

class IssueDetailsMessageCell: UITableViewCell {
    static let reuseIdentifier = "issueDetailMessageCell"

    private let messageView = UITextView()
    private var cellType: IssueEnumCell!

    var delegate: IssueCellDelegate?
    var editable: Bool? {
        didSet {
            self.messageView.isEditable = editable ?? false
            self.messageView.textColor = editable ?? false ? UIColor.black : UIColor.gray
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: IssueDetailsMessageCell.reuseIdentifier)
        initLayout()
    }
    
    private func initLayout() {
        super.awakeFromNib()
        // Initialization code
        
        messageView.isScrollEnabled = false
        messageView.textContainer.heightTracksTextView = true
        messageView.returnKeyType = .done
        messageView.delegate = self
        messageView.font = UIFont.systemFont(ofSize: 16.0)
        self.contentView.addSubview(messageView)
        
        messageView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(20.0)
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(with message: String, type: IssueEnumCell){
        self.messageView.text = message
        self.cellType = type
    }

}

extension IssueDetailsMessageCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        delegate?.changeText(field: cellType, value: messageView.text)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        delegate?.didEndChangeText(field: cellType, value: messageView.text)
    }
    
}
