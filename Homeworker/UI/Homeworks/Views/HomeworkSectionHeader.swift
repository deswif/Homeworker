//
//  HomeworkSectionHeader.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import UIKit

class HomeworkSectionHeader: UICollectionReusableView {
    
    static let identifier = "HomeworkSectionHeader"
    
    var title: String? {
        get {
            label.text
        }
        
        set(newTitle) {
            label.text = newTitle
        }
    }
    
     private var label: UILabel = {
         let label: UILabel = UILabel()
         label.textColor = .label
         label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
         label.sizeToFit()
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()

     override init(frame: CGRect) {
         super.init(frame: frame)

         addSubview(label)
         
         
         label.snp.makeConstraints { make in
             make.bottom.equalToSuperview().offset(-5)
             make.leading.equalToSuperview()
         }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
