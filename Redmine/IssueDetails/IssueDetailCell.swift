//
//  IssueDetailCell.swift
//  Redmine
//
//  Created by Евгений Куринной on 7/15/19.
//  Copyright © 2019 Evgeniy Kurinnoy. All rights reserved.
//

import UIKit
import SnapKit

class IssueDetailCell: UITableViewCell {
    static let reuseIdentifier = "issueDetailCell"
    
    private let titleLabel = UILabel()
    private let infoLabel = UITextField()
    private var cellType: IssueEnumCell!

    var delegate: IssueCellDelegate?
    
    var editable: Bool? {
        didSet {
            self.infoLabel.isEnabled = false
            self.infoLabel.textColor = UIColor.black
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
        super.init(style: .default, reuseIdentifier: IssueDetailCell.reuseIdentifier)
        initLayout()
    }
    
    private func initLayout() {
        super.awakeFromNib()
        
        titleLabel.textColor = UIColor.blue
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        
        infoLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        infoLabel.textColor = UIColor.black
        infoLabel.returnKeyType = .done
        infoLabel.delegate = self

        self.addSubview(titleLabel)
        self.addSubview(infoLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self.snp.centerX).multipliedBy(0.7)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(titleLabel.snp.trailing).offset(20.0)
            make.trailing.equalTo(self.snp.trailing).offset(20.0)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(with title: String, info: String, type: IssueEnumCell) {
        titleLabel.text = title
        infoLabel.text = info
        self.cellType = type
    }

}

extension IssueDetailCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        delegate?.didEndChangeText(field: cellType, value: infoLabel.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.changeText(field: cellType, value: infoLabel.text ?? "")
        return true
    }
}
