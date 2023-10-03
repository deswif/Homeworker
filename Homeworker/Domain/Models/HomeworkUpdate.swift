//
//  HomeworkUpdate.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation

class HomeworkUpdate {
    let title: String?
    let subject: String?
    let endDate: Date?
    let status: HomeworkStatus?
    
    init(title: String? = nil, subject: String? = nil, endDate: Date? = nil, status: HomeworkStatus? = nil) {
        self.title = title
        self.subject = subject
        self.endDate = endDate
        self.status = status
    }
}
