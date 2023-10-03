//
//  CreateHomeworkButton.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import UIKit

class CreateHomeworkButton: CustomButton {
    
    private let plusIcon: UIImageView = {
        let image = UIImage(systemName: "pencil")
        let view = UIImageView(image: image)
        view.tintColor = .label
        
        return view
    }()

    override init() {
        super.init()
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        backgroundColor = .systemBlue
        
        addSubview(plusIcon)
        
        plusIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 3
    }
    
}
