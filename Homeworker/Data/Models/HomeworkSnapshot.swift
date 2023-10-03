//
//  HomeworkSnapshot.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation
import GRDB

struct HomeworkSnapshot: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var title: String
    var subject: String
    var endDate: Date
    var status: String
    
    static var databaseTableName: String = "homeworks"
}

