//
//  CreateHomeworkField.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import UIKit

class CreateHomeworkField: UITextField {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .systemGray5
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
