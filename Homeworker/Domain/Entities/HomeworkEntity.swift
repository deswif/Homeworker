//
//  HomeworkEntity.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import Foundation

struct HomeworkEntity: Equatable {
    let id: Int64
    let title: String
    let subject: String
    let status: HomeworkStatus
    let endDate: Date?
    
    static func == (lhs: HomeworkEntity, rhs: HomeworkEntity) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.subject == rhs.subject &&
        lhs.status == rhs.status &&
        lhs.endDate == rhs.endDate
    }
}
