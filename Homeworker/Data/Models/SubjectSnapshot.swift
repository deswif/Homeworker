//
//  SubjectSnapshot.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import Foundation
import GRDB

struct SubjectSnapshot: Codable, FetchableRecord, PersistableRecord {
    let name: String
    
    static var databaseTableName = "subjects"
}
