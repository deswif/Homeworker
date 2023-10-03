//
//  HomeworkDetailsViewController.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import UIKit

class HomeworkDetailsViewController: UIViewController {
    
    var homework: HomeworkEntity! {
        didSet {
            navigationItem.title = homework.subject
            taskTitleView.text = homework.title
            statusView.text = "Status: \(homework.status.rawValue)"
            var endDateText: String
            if homework.endDate == nil {
                endDateText = "-"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMMM, HH:mm"
                endDateText = dateFormatter.string(from: homework.endDate!)
            }
            
            endDateView.text = "End date: \(endDateText)"
        }
    }
    
    private let taskTitleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let taskTitleView: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .label
        view.font = .systemFont(ofSize: 26, weight: .semibold)
        view.textAlignment = .center
        
        return view
    }()
    
    private let statusView: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return view
    }()
    
    private let endDateView: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureTaskTitle()
        configureStatus()
        configureEndDate()
    }
    
    private func configureTaskTitle() {
        view.addSubview(taskTitleContainer)
        taskTitleContainer.addSubview(taskTitleView)
        
        taskTitleContainer.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(40)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(-40)
            make.width.greaterThanOrEqualTo(150)
        }
        
        taskTitleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func configureStatus() {
        view.addSubview(statusView)
        
        statusView.snp.makeConstraints { make in
            make.top.equalTo(taskTitleContainer.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func configureEndDate() {
        view.addSubview(endDateView)
        
        endDateView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
    }
}
