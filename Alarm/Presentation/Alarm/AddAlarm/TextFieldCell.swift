//
//  TextFieldCell.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-27.
//

import SnapKit
import Then
import UIKit

class TextFieldCell: UITableViewCell {
    
    private lazy var leadingLabel = UILabel().then({
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = UIColor.black
        $0.numberOfLines = 1
    })
    
    private lazy var trailingTextField = UITextField().then({
        $0.textAlignment = .right
        $0.tintColor = UIColor.black
        $0.borderStyle = .none
        $0.placeholder = "알람"
    })
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        selectionStyle = .none
        
        contentView.addSubview(leadingLabel)
        contentView.addSubview(trailingTextField)
        contentView.clipsToBounds = true
    }
    
    func setLayout() {
        leadingLabel.snp.makeConstraints({ constraint in
            constraint.leading.equalToSuperview().offset(8)
            constraint.centerY.equalToSuperview()
        })
        
        trailingTextField.snp.makeConstraints({ constraint in
            constraint.trailing.equalToSuperview().offset(-8)
            constraint.centerY.equalTo(leadingLabel)
        })
    }
    
    func configure(with leadingLabelText: String) {
        leadingLabel.text = leadingLabelText
    }
    
}
