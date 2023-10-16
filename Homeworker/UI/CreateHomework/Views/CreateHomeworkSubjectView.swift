//
//  CreateHomeworkSubjectView.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import UIKit
import RxSwift

class CreateHomeworkSubjectView: UIView {
    
    private let bag = DisposeBag()
    
    var openPicker: (() -> Void)?
    
    var pickedSubject: SubjectEntity? {
        didSet {
            if let pickedSubject {
                button.setTitle(pickedSubject.name, for: .normal)
                button.backgroundColor = .white.withAlphaComponent(0.2)
            } else {
                button.setTitle("Pick", for: .normal)
                button.backgroundColor = .white.withAlphaComponent(0.5)
            }
        }
    }
    
    private let label: UILabel = {
        let view = UILabel()
        view.text = "Subject:"
        view.font = .preferredFont(forTextStyle: .caption1)
        
        return view
    }()
    
    private let button: CustomButton = {
        let view = CustomButton()
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        view.setTitle("Pick", for: .normal)
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 8
        view.titleLabel!.lineBreakMode = .byTruncatingTail
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        button.rx.tap.subscribe { [weak self] _ in
            self?.openPicker?()
        }.disposed(by: bag)
        
        addSubview(label)
        addSubview(button)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.greaterThanOrEqualTo(label.snp.trailing).offset(10)
        }
        
    }
    
}
