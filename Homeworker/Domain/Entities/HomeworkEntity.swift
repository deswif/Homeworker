//
//  HomeworkEntity.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import Foundation

struct HomeworkEntity: Hashable {
    let id: Int64
    let title: String
    let subject: String
    let status: HomeworkStatus
    let endDate: Date?
}
